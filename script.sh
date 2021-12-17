#!/bin/bash



SELECT_COMPONENT_NAME=(INGESTOR JOINER WRANGLER VALIDATOR)
SELECT_VIEW=(Auction Bid)
SELECT_SCALE_VAR=(LOW MID HIGH)
SELECT_COUNT=({1..9})



# calling the function and storing the users value
COMPONENT_NAME=$1
VIEW=$2
SCALE_VAR=$3
COUNT=$4
value=$5




if [[ " ${SELECT_COMPONENT_NAME[*]} " =~ " $COMPONENT_NAME " ]]; then
        echo "Selected Component $COMPONENT_NAME"
    else
        echo "Wrong input: $COMPONENT_NAME"
        exit
fi

        
if [[ " ${SELECT_VIEW[*]} " =~ " $VIEW" ]]; then
        echo "Selected Component $VIEW"
    else
        echo "Wrong input: $VIEW"
        exit
fi


if [[ " ${SELECT_SCALE_VAR[*]} " =~ " $SCALE_VAR" ]]; then
        echo "Selected Component $SCALE_VAR"
    else
        echo "Wrong input: $SCALE_VAR"
        exit
fi


if [[ " ${SELECT_COUNT[*]} " =~ " $COUNT" ]]; then
        echo "Selected Component $COUNT"
    else
        echo "Wrong input: $COUNT"
        exit
fi



# matching the parameters and changing the content of file according to that
if [ "$VIEW" == "Auction" ]; then
    

    if cat sig.conf | grep -n -v "$value" | grep -n -q "$COMPONENT_NAME" ; then
        L=$( cat sig.conf | grep -n -v "$value" | grep  "$COMPONENT_NAME" | awk -F ':' '{print $1}')
        PREVIOUS_SCALE=$( cat sig.conf | grep -n -v "$value" | grep -n "$COMPONENT_NAME" | awk -F ';' '{print $2}'  )
        PREVIOUS_COUNT=$( cat sig.conf | grep -n -v "$value" | grep -n "$COMPONENT_NAME" | awk -F '=' '{print $2}'  )
        sed -i "${L}s/${PREVIOUS_SCALE}/${SCALE_VAR}/" sig.conf 
        sed -i "${L}s/${PREVIOUS_COUNT}/${COUNT}/" sig.conf
        echo "sig.conf is changed now, check line number $L"
    else
        echo "Your select view and component name is not present in sig.conf file. Please try again"
    fi


else

    if cat sig.conf | grep -n  "$value" | grep -n -q "$COMPONENT_NAME"; then
        L=$( cat sig.conf | grep -n "$value" | grep  "$COMPONENT_NAME" | awk -F ':' '{print $1}')
        PREVIOUS_SCALE=$( cat sig.conf | grep -n "$value" | grep -n "$COMPONENT_NAME" | awk -F ';' '{print $2}'  )
        PREVIOUS_COUNT=$( cat sig.conf | grep -n  "$value" | grep -n "$COMPONENT_NAME" | awk -F '=' '{print $2}'  ) 
        sed -i "${L}s/${PREVIOUS_SCALE}/${SCALE_VAR}/" sig.conf
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
