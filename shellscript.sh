#!/bin/bash



function choose(){
list=("${!1}")
PS3="$2"
select value in ${list[@]}; do
    if [[ " ${list[*]} " =~ " $value " ]]; then
        echo "You have selected: $value" >&2
        echo "$value"
        break
    else
        echo "   $REPLY is invalid selection, please select the vaild option" >&2
    fi
    
done
}

component_array=(INGESTOR JOINER WRANGLER VALIDATOR)
component_ps3="Please select the component name: "

view_array=(Auction Bid)
view_ps3="Please select the view: "

scale_array=(LOW MID HIGH)
scale_ps3="Please select the scale: "

count_array=({1..9})
count_ps3="Please select the count: "


component=$( choose component_array[@] "$component_ps3" )
view=$( choose view_array[@] "$view_ps3" )
scale=$( choose scale_array[@] "$scale_ps3" )
count=$( choose count_array[@] "$count_ps3" )


if [ "$view" == "Auction" ];
    then    
        if cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n -q "$component" ;
           then
                line_number=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep  "$component" | awk -F ':' '{print $1}')
                default_scale=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n "$component" | awk -F ';' '{print $2}'  )
                default_count=$( cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n "$component" | awk -F '=' '{print $2}'  )
                sed -i "${line_number}s/${default_scale}/${scale}/" sig.conf 
                sed -i "${line_number}s/${default_count}/${count}/" sig.conf
                
                echo "sig.conf file has been changed"
                logger "sig.conf file has been changed" -t SigScript 
            else
                echo "your selected inputs are not present in the sig.conf file"
                logger "your selected inputs are not present in the sig.conf file" -t SigScript 
            fi
    else
        if cat sig.conf | grep -n  "vdopiasample-bid" | grep -n -q "$component";
        then
            line_number=$( cat sig.conf | grep -n "vdopiasample-bid" | grep  "$component" | awk -F ':' '{print $1}')
            default_scale=$( cat sig.conf | grep -n "vdopiasample-bid" | grep -n "$component" | awk -F ';' '{print $2}'  )
            default_count=$( cat sig.conf | grep -n  "vdopiasample-bid" | grep -n "$component" | awk -F '=' '{print $2}'  )
            sed -i "${line_number}s/${default_scale}/${scale}/" sig.conf
            sed -i "${line_number}s/${default_count}/${count}/" sig.conf
            
            echo  "sig.conf file has been changed"
            logger "sig.conf file has been changed" -t SigScript 
        else
            echo  "your selected inputs are not present in the sig.conf file"
            logger "your selected inputs are not present in the sig.conf file" -t SigScript 
        fi
fi

