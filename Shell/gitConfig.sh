user=cdu.cn.bj

#配置push review
cd .git

#配置user.name/user.email
git config --global --unset user.name
git config --global --unset user.email
git config --global user.email "$user"@hotmail.com
git config --global user.name "dudaye"
git config --list

#配置忽略文件权限
git config --global core.fileMode false


