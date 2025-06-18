# env vars

export CLANGCXX=clang++
export CLANGC=clang

# Bash Functions

function c {
	cd $1
}

mkcd(){
    mkdir -p $1
    cd $1	
}

vims(){
    vim $1
    source $1
}

usrc(){
  curr_dir=`pwd`
  if [ "$1" != "" ]; then
    curr_dir=$1
  fi
  source ~/.bashrc
}

gitcd(){
	if [ $# -eq 2 ]
	then 
		git clone $1 $2		
		cd $2
	else
        git clone $1
	    to_cd=`echo $1 | sed 's/\//\n/g' | awk END{print} | sed 's/\./\n/g' | head -1`
        cd $to_cd
	fi
	
}

title(){
	temp=`python3 -c "print('$1'.title())"`
    echo $temp | xclip -selection clipboard
}

small(){
	temp=`python3 -c "print('$1'.lower())"`
    echo $temp | xclip -selection clipboard
}

cpfile(){
    cat $1 | xclip -selection clipboard
}

download-length(){
    length_bytes=`curl -sI $1| grep -i Content-Length | awk '{print $2}'`
    python3 -c "print('{} MB'.format(round($length_bytes/1024/1024,1)))"
}

ntimes(){
    if [ $# -le 1 ]
    then
        echo "error: Not enough arguments"
        echo "usage: ntimes command times"
    fi
    for ((c=0; c<$2; c++)) 
    do
        $1
    done
}

up(){
    ntimes "cd .." $1
}

netcheck(){
    ping 1.1.1.1
}

copyout(){
    $1 &> /tmp/pk_temp
    cpfile /tmp/pk_temp
    rm /tmp/pk_temp

}

cpcmd(){
    echo $1 | xclip -selection clipboard
}

cpp_ast_dump(){
    CLANGCXX -Xclang -ast-dump -fsyntax-only $1
}

getLatest(){
    result=(`ls -t $1`)
    echo $1/$result
}

git_size(){
    user=`echo $1 | sed 's/\// /g' | awk '{print $(NF-1)}'`
    repo=`echo $1 | sed 's/\//\n/g' | awk END{print} | sed 's/\./\n/g' | head -1`
    result=`curl -s https://api.github.com/repos/$user/$repo | grep -Po "\"size\": \K([\d]*)"`
    python3 -c "print($result / 1024, 'MB')" 
}

bash_map(){
  job=$1
  files=$2
  echo $files 
}

function rvs {
  export VSCODE_IPC_HOOK_CLI="$(ls -t1 /run/user/$(id -u)/vscode-ipc-* | head -n 1)"
}

# adds to the path to LD_LIBRARY_PATH env variable
add_libpath(){
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$1
}

mount_at(){
    this=$1
    at=$2
    sudo mkdir -p $2
    sudo mount $1 $2
}

unmount(){
    sudo umount $1
}

hedwig() {
    $BOS/howler.py $BOS/configs/regular_config.yaml "$@"
}

regress() {
  echo -e "$1\n $2" | python3 -c "a = float(input()); b = float(input()); print(((a - b) / a) * 100);"
}

function pretty_csv {
  column -t -s, -n "$@" | less -F -S -X -K
}

function ff {
	find . -name $1
}

# tmux shortcuts

function ta {
  tmux attach -t $1
}

function tn {
  dir=`basename $(pwd)`
  if [ "$1" != "" ]; then
    dir=$1
  fi
  tmux rename-window $dir
}

function tl {
	tmux ls
}

function tmr {
	export $(tmux show-environment | grep "^PATH")
}

function trs {
	tmux rename-session $1
}

function dwn {
	cd ~/Downloads
}
# tmux shortcuts end

if [ -d "$HOME/.vscode-server/bin" ]; then
	export PATH="${HOME}/.vscode-server/bin/$(ls -t1 ${HOME}/.vscode-server/bin | head -n 1)/bin:${PATH}"
fi

if [ -d "/run/user/$(id -u)/vscode-ipc-*" ]; then
	export VSCODE_IPC_HOOK_CLI="$(ls -t1 /run/user/$(id -u)/vscode-ipc-* | head -n 1)"
fi

#export VSCODE_IPC_HOOK_CLI="$(ls -t1 /run/user/$(id -u)/vscode-ipc-* | head -n 1)"
# Tell tmux to set these variables for new windows/panes.
# Remove if you don't use tmux
tmux has-session &> /dev/null

if [ $? == 0 ]
then
    tmux setenv PATH "$PATH"
    tmux setenv VSCODE_IPC_HOOK_CLI "$VSCODE_IPC_HOOK_CLI"
fi

# Aliases
alias open=xdg-open
alias icode="code-insiders" # vscode insider version
alias mount_softwares="mount_at /dev/sda10 /media/pradeep/Softwares"
alias mount_movies="mount_at /dev/sda7 /media/pradeep/Movies"
alias mount_wormhole="mount_at /dev/sda6 /media/pradeep/Wormhole"
alias mount_my_stuff="mount_at /dev/sda9 /media/pradeep/My_Stuff"

alias unmount_softwares="unmount /media/pradeep/Softwares"
alias unmount_movies="unmount /media/pradeep/Movies"
alias unmount_wormhole="unmount /media/pradeep/Wormhole"
alias unmount_my_stuff="unmount /media/pradeep/My_Stuff"

alias tf="tail -f"
alias lerr='less -p "error:"'

# Sourcing other files
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd)"

source $DIR/llvmrc
source $DIR/git_utils.sh
