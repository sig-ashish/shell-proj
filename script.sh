
!/bin/bash


comp_read=$1                                                    
view_read=$2                                                
scale_read=$3                                               
COUNT=$4
filename=$5


VAR="bid"
if [[ "$view_read" =~ "Auction" ]]; then
    
    LineNumber=$( cat $filename | grep -i -n  "$comp_read" | grep -i -n -v "$VAR" | awk -F ":" '{print $2}' ) 
    conf=$( cat $filename | grep -i  "$comp_read" | grep -i -v "$VAR"  )
    SCALE=$( echo $conf | awk -F ';' '{print $2}')                            
    SELECT_COUNT=$( echo $conf | awk -F '=' '{print $2}')         
    new_conf=$( echo $conf | sed  "s/$SCALE/$scale_read/g"  )

    new_conf2=$( echo $new_conf | sed  "s/$SELECT_COUNT/$COUNT/g"  )
    sed -i "s/$conf/$new_conf2/g" $filename

else
    LineNumber=$( cat $filename | grep -i -n "$comp_read" | grep -i -n "$VAR" | awk -F ":" '{print $2}' ) # conf
    conf=$( cat $filename | grep -i  "$comp_read" | grep -i  "$VAR"  )
    SCALE=$( echo $conf | awk -F ';' '{print $2}')                             # curr_scale 
    SELECT_COUNT=$( echo $conf | awk -F '=' '{print $2}')           # new_conf
    new_conf=$( echo $conf | sed  "s/$SCALE/$scale_read/g"  )

    new_conf2=$( echo $new_conf | sed  "s/$SELECT_COUNT/$COUNT/g"  )
    sed -i "s/$conf/$new_conf2/g" $filename
fi
cat $filename
~                                  

