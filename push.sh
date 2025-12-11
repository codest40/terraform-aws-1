#!/bin/bash
# push.sh – Local orchestrator for DevOps workflow
# Purpose: 3-step orchestration: secrets setup, Git push, local checks

set -e
set -o pipefail

#--------- Colors for terminal output ---------
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

arg=$1

#--------- Optional Bootstrap Mode ----------
if [[ "$arg" == "bootstrap" ]]; then
    echo -e "${YELLOW}[BOOTSTRAP] Bootstrap mode activated. Running bootstrap.sh...${NC}"
    msg="$(date)"

    if [ -f ./bootstrap.sh ]; then
        chmod +x bootstrap.sh
        ./bootstrap.sh || { echo -e "${RED}Bootstrap failed! Exiting.${NC}"; exit 1; }
        echo -e "${GREEN}[BOOTSTRAP] bootstrap.sh executed successfully.${NC}"
    else
        echo -e "${RED}[BOOTSTRAP] bootstrap.sh not found! Exiting.${NC}"
        exit 1
    fi

    echo -e "\n====================================================\n"
    sleep 2
else
    echo -e "${YELLOW}[INFO] Bootstrap skipped (run: ./push.sh bootstrap to activate).${NC}"
    echo -e "\n====================================================\n"
    msg=$(date)
fi


#--------- Step 0: Load AWS credentials ----------
echo -e "${YELLOW}[0/3] Loading AWS credentials from exporter.sh...${NC}"
if [ -f ./exporter.sh ]; then
    chmod +x exporter.sh
    source ./exporter.sh
    echo -e "${GREEN}[0/3] AWS credentials successfully exported.${NC}"
    echo "Region: $AWS_REGION"
    echo "API Key: $API_TOKEN"
else
    echo -e "${RED}[0/3] exporter.sh not found! Exiting.${NC}"
    exit 1
fi
echo -e "\n====================================================\n"

sleep 2

#--------- Step 1: Ansible Secrets Setup ---------
echo -e "${YELLOW}[1/3] Setting up AWS secrets via Ansible...${NC}"
if ansible-playbook ansible/secrets.yml; then
    echo -e "${GREEN}[1/3] Secrets setup completed successfully.${NC}"
else
    echo -e "${RED}[1/3] Secrets setup failed! Exiting.${NC}"
#    exit 1
fi
echo -e "\n====================================================\n"

sleep 2

#--------- Step 2: Git Push to Trigger CI/CD ---------
echo -e "${YELLOW}[2/3] Pushing code to GitHub to trigger CI/CD...${NC}"

git add .
git commit -m "Automated push $msg" || echo -e "${YELLOW}[2/3] No changes to commit.${NC}"

if git push origin main; then
    echo -e "${GREEN}[2/3] Git push succeeded, CI/CD triggered.${NC}"
else
    echo -e "${RED}[2/3] Git push failed! Exiting.${NC}"
    exit 1
fi
echo -e "\n====================================================\n"

sleep 3

#--------- Step 3: Local Miscellaneous Checks ---------
echo -e "${YELLOW}[3/3] Performing local post-push checks...${NC}"

if aws secretsmanager list-secrets >/dev/null 2>&1; then
    echo -e "${GREEN}[3/3] AWS secrets verified locally.${NC}"
else
    echo -e "${RED}[3/3] AWS secrets verification failed!${NC}"
fi
echo -e "\n====================================================\n"

sleep 2

echo -e "${GREEN}[✔] Workflow completed. All steps executed.${NC}"
echo "Removing .env file now.. "
if [ -f .env ]; then
    rm .env
fi
exit 0

