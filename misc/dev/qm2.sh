

command_not_found_handle() {
        echo "'$rawinput' not a valid command "
        return 0
        }


setup=true
source misc/setting/config.env







echo "
School File Program v1
Based on Quickmacro Program v1
by: Raiden Horner "

if $setup; then
	echo "please run command 'setup'\n"
fi

while true; do
	dir=$(basename "$PWD")
	read -p "${dir}: " rawinput
	IFS=" " read -ra user_input <<< "$rawinput"

	case "${user_input[0]}" in 
        	"exit")
                	break
			;;

		"update")
			sudo apt update -y ; sudo apt upgrade -y ; sudo apt autoremove -y < /dev/null
			;;

		"list")	
			passthrough="${rawinput/list /}"
			if [[ "${rawinput}" == "list" ]]; then
				ls
                	elif [[ -z "$passthrough" ]]; then
                        	ls 
			else
				ls $passthrough
			fi
			;;
		"pass")
			passthrough="${rawinput/pass /}"
			if [[ -z "$passthrough" ]]; then
				echo "pass: no argument given"	
			else
				$passthrough
			fi
			;;
	
		"rename")
			mv ${user_input[1]} ${user_input[2]}
			;;
		"move")
                	mv ${user_input[1]} ${user_input[2]}
			;;
		"backup")
			
			if [[ "$dir" == "misc" ]]; then
				rm -r /media/$user/$storage/school/misc
				cp -r ~/Desktop/school/misc /media/raiden/CHROMEBOOK/school/misc
				echo "misc backed up"
			elif [[ "$dir" != "school" && "$dir" != "trash" ]]; then
				rm -r /media/$user/$storage/school/$dir/note 
        			rm -r /media/$user/$storage/school/$dir/submit
        			rm -r /media/$user/$storage/school/$dir/material
        			cp -r note /media/$user/$storage/school/$dir/note
        			cp -r submit /media/$user/$storage/school/$dir/submit
        			cp -r material /media/$user/$storage/school/$dir/material
				echo "class $dir backed up"
			else
				echo "Cannot backup Directory"
			fi
			;;

		"mkclass")
			mkdir ~/Desktop/school/${user_input[1]}
			mkdir ~/Desktop/school/${user_input[1]}/note
			mkdir ~/Desktop/school/${user_input[1]}/submit
			mkdir ~/Desktop/school/${user_input[1]}/material
			mkdir /media/$user/$storage/school/${user_input[1]} 
			mkdir /media/$user/$storag/school/${user_input[1]}/note 
               		mkdir /media/$user/$storag/school/${user_input[1]}/submit
                	mkdir /media/$user/$storag/school/${user_input[1]}/material
			;;
		"class")
			passthrough="${rawinput/class /}"
			if [[ "${rawinput}" == "class" ]]; then
				tmp=$(ls /home/raiden/Desktop/school)
				passthrough="${tmp//$'\n'/ }"
				passthrough="${passthrough/trash /}"
				passthrough="${passthrough/qm.sh /}"
				passthrough="${passthrough/misc /}"
				echo "$passthrough"
                	else
                        	cd ~/Desktop/school/${user_input[1]}
                	fi
			;;
		"edit")           
                	passthrough="${rawinput/edit /}"
                	if [[ "${rawinput}" == "edit" ]]; then
                        	vim
                	elif [[ -z "$passthrough" ]]; then
                        	vim
                	else
                        	vim $passthrough
                	fi
			;;
		"del" | "rm" | "delete" | "remove")
			passthrough="${rawinput/del /}"
			passthrough="${passthrough/rm /}"
			passthrough="${passthrough/delete /}"
			passthrough="${passthrough/remove /}"
                        if [[ -z "$passthrough" ]]; then
                                echo "del: no argument given" 
			elif [[ ${user_input[1]} == "trash" ]]; then
				rm -r ~/Desktop/school/trash
				mkdir ~/Desktop/school/trash
				echo "trash emptied"
                        else
				mv ${user_input[1]} ~/Desktop/school/trash
			fi

			;;
		"trash")
			
			if [[ ${user_input[1]} == "empty" ]]; then
                                rm -r ~/Desktop/school/trash
                                mkdir ~/Desktop/school/trash
                                echo "trash emptied"
			else
				ls ~/Desktop/school/trash
			fi
			;;
		"setup")
			mkdir school
			mv qm.sh school
			cd school
			mkdir trash
			mkdir misc
			mkdir misc/setting
			mkdir misc/setting/config.env
			echo "setup=false" >> misc/setting/config.env
			;;
		"help")
			echo "${helpstring}" 
			;;

        	*)
                	$rawinput
			;;

        esac

done
