# GitHub Actions Capstone

A small Flask app used to demonstrate a complete, production-style CI/CD
pipeline built entirely with GitHub Actions — reusable workflows, a
tests-only PR gate, Docker build/push on merge, a scheduled health check,
and a DevSecOps vulnerability scan.

> Replace `<your-username>` below with your GitHub username/org once you push this repo.

## Status

![PR Pipeline](https://github.com/<your-username>/github-actions-capstone/actions/workflows/pr-pipeline.yml/badge.svg)
![Main Pipeline](https://github.com/<your-username>/github-actions-capstone/actions/workflows/main-pipeline.yml/badge.svg)
![Health Check](https://github.com/<your-username>/github-actions-capstone/actions/workflows/health-check.yml/badge.svg)

## What's in here

- `app.py` — Flask app with `/` and `/health` endpoints
- `test_app.py` — pytest suite run by the build-test workflow
- `test_health.sh` — curl-based smoke test used by the health-check workflow
- `Dockerfile` — containerizes the app
- `.github/workflows/`
  - `reusable-build-test.yml` — installs deps, runs pytest, emits `test_result`
  - `reusable-docker.yml` — logs in to Docker Hub, builds & pushes the image, emits `image_url`
  - `pr-pipeline.yml` — runs on PRs into `main`; tests only, no image push
  - `main-pipeline.yml` — runs on push to `main`; test → build/push (`latest` + `sha-<short>`) → Trivy scan → deploy
  - `health-check.yml` — runs every 12 hours (+ manual trigger); pulls the image, hits `/health`, reports pass/fail

## Required repo configuration

**Secrets** (Settings → Secrets and variables → Actions):
- `DOCKER_USERNAME`
- `DOCKER_TOKEN`

**Environment** (Settings → Environments):
- `production` — optionally add required reviewers for manual approval before deploy

## Running locally

```bash
pip install -r requirements.txt
python app.py
# in another shell
./test_health.sh
```

## Running with Docker

```bash
docker build -t github-actions-capstone .
docker run -d -p 5000:5000 --name capstone-app github-actions-capstone
curl http://localhost:5000/health
docker stop capstone-app && docker rm capstone-app
```

Full pipeline architecture and notes: see [`day-48-actions-project.md`](./day-48-actions-project.md).
