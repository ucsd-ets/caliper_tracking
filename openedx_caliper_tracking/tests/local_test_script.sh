#!/bin/bash
# This script file is to run the caliper app tests locally.

if [ "$(ls | grep -w openedx-caliper-tracking)" != "" ]; then
    FOLDER_NAME="caliper_app_testing"
    PROJECT_NAME="caliper_project"
    rm -rf $FOLDER_NAME
    mkdir $FOLDER_NAME
    cd $FOLDER_NAME

    printf "\n\n\n=========================================\n"
    printf "Making and Activating Virtual Environment"
    printf "\n=========================================\n"
    virtualenv venv --python=python2.7
    source venv/bin/activate

    printf "\n\n\n=======================\n"
    printf "Installing Dependencies"
    printf "\n=======================\n"
    pip install  ../openedx-caliper-tracking
    pip install -r venv/lib/python2.7/site-packages/openedx_caliper_tracking/tests/test_requirements.txt

    printf "\n\n\n=======================\n"
    printf "Creating Django Project"
    printf "\n=======================\n"
    django-admin.py startproject $PROJECT_NAME
    sudo apt-get install sed
    cd $PROJECT_NAME/$PROJECT_NAME/
    # Append 'openedx_caliper_tracking' in INSTALLED_APPS list of settings.py
    sed "/'django.contrib.staticfiles',/a 'openedx_caliper_tracking'" settings.py > temp_settings.py
    rm settings.py
    mv temp_settings.py settings.py
    cd ..

    printf "\n\n\n=====================\n"
    printf "Running Caliper Tests"
    printf "\n=====================\n"
    coverage run --source='openedx_caliper_tracking' manage.py test openedx_caliper_tracking
    coverage report --omit='*tests*, *pavement.py*, *__init__.py*'
    deactivate
    cd ../..
    rm -rf $FOLDER_NAME
else
    echo "Your current directory doesn't contain the package named openedx-caliper-tracking."
fi
