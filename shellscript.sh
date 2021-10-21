#!/bin/bash


COMPONENT_LIST=( INGESTOR JOINER WRANGLER VALIDATOR )
echo "Please select the component name:"
select COMPONENT_NAME in "${COMPONENT_LIST[@]}"; do
    if [[ " ${COMPONENT_LIST[*]} " == *" $COMPONENT_NAME "* ]]; then
        echo "You have selected$COMPONENT_NAME"
        break
    else
        echo "invalid selection: $REPLY"
        echo "Please select the valid component name"
    fi
done
VIEW_LIST=( Auction Bid )
echo "Please select the view:"
select VIEW in "${VIEW_LIST[@]}"; do
    if [[ " ${VIEW_LIST[*]} " == *" $VIEW "* ]]; then
        echo "you have selected $VIEW"
        break
    else
        echo "invalid selection: $REPLY"
        echo "Please select the valid view"
    fi
done
SCALE_LIST=( LOW MID HIGH )
echo "Please select the scale:"
select SCALE in "${SCALE_LIST[@]}"; do
    if [[ " ${SCALE_LIST[*]} " == *" $SCALE "* ]]; then
        echo "you have selected $SCALE"
        break
    else
        echo "invalid selection: $REPLY"
        echo "Please select the valid scale"
    fi
done
COUNT_LIST=( 1 2 3 4 5 6 7 8 9)
echo "Please select the count:"
select COUNT in "${COUNT_LIST[@]}"; do
    if [[ " ${COUNT_LIST[*]} " == *" $COUNT "* ]]; then
        echo "you have selected $COUNT"
        break
    else
        echo "invalid selection: $REPLY"
        echo "Please select the valid count"
    fi
done

if [ "$VIEW" == "Auction" ];
    then    
        if cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n -q "$COMPONENT_NAME" ;
           then
                LINE_NUMBER=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep  "$COMPONENT_NAME" | awk -F ':' '{print $1}')
                DEFAULT_SCALE=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F ';' '{print $2}'  )
                DEFAULT_COUNT=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F '=' '{print $2}'  )
                sed -i "${LINE_NUMBER}s/${DEFAULT_SCALE}/${SCALE}/" sig.conf
                sed -i "${LINE_NUMBER}s/${DEFAULT_COUNT}/${COUNT}/" sig.conf

                echo "sig.conf file has been changed"
            else
                echo "your selected inputs are not present in the sig.conf file"
            fi
    else
        if cat sig.conf | grep -n  "vdopiasample-bid" | grep -n -q "$COMPONENT_NAME";
        then
            LINE_NUMBER=$( cat sig.conf | grep -n "vdopiasample-bid" | grep  "$COMPONENT_NAME" | awk -F ':' '{print $1}')
            DEFAULT_SCALE=$( cat sig.conf | grep -n "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F ';' '{print $2}'  )
            DEFAULT_COUNT=$( cat sig.conf | grep -n  "vdopiasample-bid" | grep -n "$COMPONENT_NAME" | awk -F '=' '{print $2}'  )
            sed -i "${LINE_NUMBER}s/${DEFAULT_SCALE}/${SCALE}/" sig.conf
            sed -i "${LINE_NUMBER}s/${DEFAULT_COUNT}/${COUNT}/" sig.conf

            echo "sig.conf file has been changed"
        else
              echo "your selected inputs are not present in the sig.conf file"  
        fi
fi
