#!/bin/sh
# Module tests share one GCP project. Every test install manages the project-wide
# roles/servicenetworking.serviceAgent grant of the Service Networking robot and
# removes it on destroy. When two tests overlap, the first destroy takes the
# robot's access away and the second destroy fails with 403, leaving its
# resources behind. This gives the robot the same access through roles the
# module never manages, so one test's destroy can't break another's.
set -eu

project="${TF_VAR_project:?TF_VAR_project is not set}"
export CLOUDSDK_AUTH_ACCESS_TOKEN="${GOOGLE_OAUTH_ACCESS_TOKEN:?GOOGLE_OAUTH_ACCESS_TOKEN is not set, is the GCP integration attached?}"
export CLOUDSDK_CORE_DISABLE_PROMPTS=1

number=$(gcloud projects describe "$project" --format='value(projectNumber)')
member="serviceAccount:service-${number}@service-networking.iam.gserviceaccount.com"

for role in roles/compute.networkAdmin roles/dns.admin; do
  if gcloud projects get-iam-policy "$project" --flatten=bindings \
    --filter="bindings.role=${role} AND bindings.members:${member}" \
    --format='value(bindings.role)' | grep -q .; then
    echo "${member} already has ${role}"
    continue
  fi

  # Parallel tests may change the IAM policy at the same time; gcloud then fails
  # with a concurrency error instead of overwriting, so retry.
  attempt=1
  until gcloud projects add-iam-policy-binding "$project" --member="$member" \
    --role="$role" --condition=None --format=none; do
    if [ "$attempt" -ge 5 ]; then
      echo "could not grant ${role} to ${member}" >&2
      exit 1
    fi
    sleep $((attempt * 5))
    attempt=$((attempt + 1))
  done
  echo "granted ${role} to ${member}"
done
