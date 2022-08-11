#!/opt/homebrew/bin/bash

# ------------------------------------------------------------------
# function:
#          init env file
# usages  :
# #################################################################
# # # dictionary: some values 
# # declare -A INIT_LIST
# # [LOG_DIR]="~/logs" \
# # )
# #
# # source ./init.sh
# ##################################################################
# version  : 1.0
# ------------------------------------------------------------------


SHELL_DIR="$( cd "$( dirname "$0" )" && pwd )"

# 若文件不存在 创建文件
env_name=$SHELL_DIR/env/env_"$(basename $0)"

# rm -rf $env_name
if [[ ! -f $env_name ]]; then
    echo "文件不存在: $env_name"
    mkdir -p $SHELL_DIR/env
    touch $env_name
    echo "#!/bin/bash" > $env_name
    echo "" >> $env_name
    chmod u+x $env_name
fi


isFix="F"
# 判断变量是否存在，若不存在插入默认值
for var in ${!INIT_LIST[@]}
do
    echo $var
    echo "$var=\"${INIT_LIST[$var]}\""
    if [[ $(cat $env_name | grep -vE "^$|^#" | awk -F "=" '{print $1}' | grep -w "$var" | wc -l) -eq "0" ]];then
        echo "$var=\"${INIT_LIST[$var]}\"" >> $env_name
        isFix="T"
    fi
done

if [[ "$isFix" == "T" ]];then
    vim $env_name
fi


echo "================================"
cat $env_name
echo "================================"


source $env_name
