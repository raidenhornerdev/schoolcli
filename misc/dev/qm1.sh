
echo "
School File Program v1
Based on Quickmacro Program v1
by: Raiden Horner
"

command_not_found_handle() {
	echo "'$rawinput' not a valid command "
	return 0
	}

helpstring="
Macro program help:
For the terminal level help please type 'pass help'

Base Commands:
update - apt update, upgrade, autoremove
list - ls
pass - pass the argument that follows directley to the terminal
exit - exit this program
rename - renames file
move - moves file


School Commands:
setup - makes the base foundations for this
backup - backs up to set device if you are in a class
mkclass - makes class with the following argument
class - quick jump to classes, without argument list all classes
edit - open file or directory in text editor
delete / del / remove / rm - moves file to trash
trash - views trash can

"

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
				rm -r /media/raiden/CHROMEBOOK/school/misc
				cp -r ~/Desktop/school/misc /media/raiden/CHROMEBOOK/school/misc
				echo "misc backed up"
			elif [[ "$dir" != "school" && "$dir" != "trash" ]]; then
				rm -r /media/raiden/CHROMEBOOK/school/$dir/note 
        			rm -r /media/raiden/CHROMEBOOK/school/$dir/submit
        			rm -r /media/raiden/CHROMEBOOK/school/$dir/material
        			cp -r note /media/raiden/CHROMEBOOK/school/$dir/note
        			cp -r submit /media/raiden/CHROMEBOOK/school/$dir/submit
        			cp -r material /media/raiden/CHROMEBOOK/school/$dir/material
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
			mkdir /media/raiden/CHROMEBOOK/school/${user_input[1]} 
			mkdir /media/raiden/CHROMEBOOK/school/${user_input[1]}/note 
               		mkdir /media/raiden/CHROMEBOOK/school/${user_input[1]}/submit
                	mkdir /media/raiden/CHROMEBOOK/school/${user_input[1]}/material
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
		"help")
			echo "${helpstring}" 
			;;

        	*)
                	$rawinput
			;;

        esac

done
