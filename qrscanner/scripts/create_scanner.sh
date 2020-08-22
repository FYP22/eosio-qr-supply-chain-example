#!/bin/bash
echo ""
echo "+------------------------------------------------------+"
echo "|                       Welcome                        |"
echo "+------------------------------------------------------+"
echo "| Account Name: 1-12 character name of the             |"
echo "|               corresponding blockchain account       |"
echo "|                                                      |"
echo "| Country Code: 2-3 character ISO country code (ex: US)|"
echo "|                                                      |"
echo "| Region: Region within the country that the scanner   |"
echo "|         will reside. Region with 2-3 digit zone.     |"
echo "|         Example: WEST-03, EAST-01, CENTRAL-08        |"
echo "+------------------------------------------------------+"
echo ""

read -p "Enter account name for the scanner: " accountName
read -p "Enter country code for the scanner: " countryCode
read -p "Enter the region of the scanner:    " region

echo ""
echo "Account name: ${accountName}"
echo "Location:     ${countryCode} ${region}"
echo ""

read -sp "Is this right? [y/n]   " confirm

if [[ $confirm = y ]] ; then
    python3 config.py ${accountName} ${countryCode} ${region}
    mkdir build && cd build && \
        cmake .. && \
        cmake --build .
fi