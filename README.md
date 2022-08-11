# script
该脚本主要是把工作中常用的脚本做下整理，提高工作效率
* ps 目前运行环境未mac
* 由于mac版本的默认bash版本为3.X，需升级到4.X以上才支持字典语法。所以我的脚本的第一行bash的路径都改成了`/opt/homebrew/bin/bash`
百度了下
https://blog.csdn.net/kaixinjiaoluo/article/details/120753099

## init.sh
该脚本用于初始化变量值
* ps: 必须使用bash4.0以上版本，bash4.0以下不支持字典

- 脚本内容
```bash
#!/bin/bash
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

source $env_name

```

- 使用方法
调用init.sh后，会在当前文件夹下生成env目录，文件名称为`env/env_+本脚本名称`
```bash
declare -A INIT_LIST
INIT_LIST=(
[LOG_DIR]="~/logs" \
)

source ./init.sh
```


## cm
该脚本，可以打开多个互不干涉的chrome浏览器，并支持代理。
* ps: 该脚本目前为mac版,
```bash
#!/bin/bash

# config
CHROM_CACHE_NAME=".chromeCache"
APP_NAME="Google Chrome"
PROXY_SERVER="127.0.0.1:7890"

ARGS=""

# init
HOME="$(cd && pwd)"
CACHE_PATH=${HOME}/${CHROM_CACHE_NAME}

# paramter qa
if [ $# -gt 0 ] ; then # -gt 大于
	CACHE_DIR="${CACHE_PATH}/$1"
	ARGS=$ARGS" --args --user-data-dir="$CACHE_DIR

	if [[ $1 == "x" && -n ${PROXY_SERVER} ]]; then # -n 非空为true； -z 空为true
		ARGS=$ARGS" --proxy-server=127.0.0.1:7890"
	fi
fi

# create dir
if [ ! -r "${CACHE_DIR}" ]; then
    echo "mkdir ${CACHE_DIR}"
    mkdir -p ${CACHE_DIR}
fi

# run command
echo "open --new -a ${APP_NAME} ${ARGS}"
open --new -a "${APP_NAME}" ${ARGS}

```

另附windows启动脚本
```bat
start Chrome  --args --user-data-dir=%USERPROFILE%\.chromeCache/1
```