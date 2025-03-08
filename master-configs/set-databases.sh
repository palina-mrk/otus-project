#!/bin/bash

OURDIR='/home/master/configs'

sudo mysql -e "CREATE DATABASE menagerie"
sudo mysql menagerie < cr_pet_tbl.sql
sudo mysql menagerie < cr_event_tbl.sql

sudo mysql < world.sql
