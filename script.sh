#!/bin/bash

# Declaring the menu items in a variable 


SELECT_COMPONENT_NAME=(INGESTOR JOINER WRANGLER VALIDATOR)
SELECT_VIEW=(Auction Bid)
SELECT_SCALE_VAR=(LOW MID HIGH)
SELECT_COUNT=({1..9})

# menu item declaration ends



# function decalaration - starts

# function to display menu items and take value from the user
function menu_item(){
ITEM=("${!1}")
PS3="$2"
select record in "${ITEM[@]}";
do
    if [[ " ${ITEM[*]} " =~ " $record " ]]; then
        echo "Selected item: $record" >&2
        echo "$record"
        break
    else
        echo "oopsss, Seems like you have not selected the right val!!!" >&2
    fi
    
done
}

# function declaration - stops



# script - starts

cat sig.conf
echo ""
echo "==============================================================================================================================="
echo ""


VAR="Please select the value: "


# calling the function and storing the users value
echo "Select Component Name: "
COMPONENT_NAME=$( menu_item SELECT_COMPONENT_NAME[@] "$VAR")
echo "Select View: "
VIEW=$( menu_item SELECT_VIEW[@] "$VAR")
echo "Select Scale: "
SCALE_VAR=$( menu_item SELECT_SCALE_VAR[@] "$VAR")
echo "Select Count: "
COUNT=$( menu_item SELECT_COUNT[@] "$VAR")



# matching the parameters and changing the content of file according to that
if [ "$VIEW" == "Auction" ]; then

    if cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n -q "$COMPONENT_NAME" ; then
        L=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep  "$COMPONENT_NAME" | awk -F ':' '{print $1}')
        PREVIOUS_SCALE=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F ';' '{print $2}'  )
        PREVIOUS_COUNT=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F '=' '{print $2}'  )
        sed -i "${L}s/${PREVIOUS_SCALE}/${SCALE_VAR}/" sig.conf 
        sed -i "${L}s/${PREVIOUS_COUNT}/${COUNT}/" sig.conf
        echo "sig.conf is changed now, check line number $L"
    else
        echo "Your select view and component name is not present in sig.conf file. Please try again"
    fi


else

    if cat sig.conf | grep -n  "vdopiasample-bid" | grep -n -q "$COMPONENT_NAME"; then
        L=$( cat sig.conf | grep -n "vdopiasample-bid" | grep  "$COMPONENT_NAME" | awk -F ':' '{print $1}')
        PREVIOUS_SCALE=$( cat sig.conf | grep -n "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F ';' '{print $2}'  ) 
        PREVIOUS_COUNT=$( cat sig.conf | grep -n  "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F '=' '{print $2}'  ) 
        sed -i "${L}s/${PREVIOUS_SCALE}/${SCALE}/" sig.conf
        sed -i "${L}s/${PREVIOUS_COUNT}/${COUNT}/" sig.conf
        echo  "sig.conf is changed now, check line number $L"
    else
        echo  "Your select view and component name is not present in sig.conf file. Please try again"
    fi
fi


# script - end

echo ""
echo "==============================================================================================================================="
echo ""
cat sig.conf
