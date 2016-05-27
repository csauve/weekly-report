#!/usr/bin/env bash
set -e

show_usage() {
  echo "Usage: `basename $0` [-h] [-c directory | -d days]"
}

show_help() {
  echo "Automatically set up a template for your weekly report based on a previous weekly report"
  echo

  show_usage
  echo

  echo "-c       Specify a certain report to copy by directory name. Default is the directory named YYYY-MM-DD from 7 days ago"
  echo "-d       Specify a certain report to copy by number of days ago. Default is the directory named YYYY-MM-DD from 7 days ago."
  echo "-h       Display this help and exit"
}

NEW_REPORT_NAME=$(date +"%Y-%m-%d")
REPORT_TO_COPY=$(date -v -7d +"%Y-%m-%d")

while getopts ":c:d:hn" opt; do
  case $opt in
    c)
      REPORT_TO_COPY=$OPTARG
      ;;
    d)
      REPORT_TO_COPY=$(date -v -${OPTARG}d +"%Y-%m-%d")
      ;;
    h)
      show_help
      exit
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      echo
      show_usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      echo
      show_usage
      exit 1
      ;;
  esac
done

if [ -d $NEW_REPORT_NAME ]; then
  echo "ERROR: $NEW_REPORT_NAME already exists"
  exit 1
fi

if [ ! -d $REPORT_TO_COPY ]; then
  echo "ERROR: $REPORT_TO_COPY does not exist"
  exit 1
fi

echo "Copying $REPORT_TO_COPY as a template for new report: $NEW_REPORT_NAME..."

mkdir $NEW_REPORT_NAME
for filename in "index.md"; do
  cp "$REPORT_TO_COPY/$filename" "$NEW_REPORT_NAME/$filename"
done
find $NEW_REPORT_NAME -type f | xargs sed -i '' "s/${REPORT_TO_COPY}/${NEW_REPORT_NAME}/g"

echo "Your template is ready."

