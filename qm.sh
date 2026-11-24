

command_not_found_handle() {
        echo "'$rawinput' not a valid command "
        return 0
        }

source misc/setting/config.env



#TO DO
#finish schedule thing
#update helpstring
#Actually put in my schedule
#add disallow list that checks if the input is in the disallow then if it is then skip the loop
#add system for class that organizes it better




echo "
School File Program v1
Based on Quickmacro Program v1
by: Raiden Horner "



if ! git ls-remote --exit-code origin > /dev/null 2>&1; then
	echo "\nNo Internet\n"
else 
	git pull > /dev/null 2>&1
fi 








history=("0", "0", "0", "0", "0", "0", "0", "0", "0", "0")


while true; do
	
	if [[ "$PWD" != "${history[0]}" ]]; then
		#tmp=${outputdate[$b]}
           	unset 'outputdate[9]'
         	history=("${PWD}" "${history[@]}")
           	history=("${history[@]}") 
	fi

	dir=$(basename "$PWD")
	read -p "${dir}: " rawinput
	IFS=" " read -ra user_input <<< "$rawinput"

	case "${user_input[0]}" in 
        	"exit")

			date=$(date +"%m-%d-%Y")
                        git add . > /dev/null 2>&1
                        git commit -m "$date" > /dev/null 2>&1
                        git push > /dev/null 2>&1
                        echo "Files backed up"
                	break
			;;

		"update")
			sudo apt update -y ; sudo apt upgrade -y ; sudo apt autoremove -y
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
			date=$(date +"%m-%d-%Y")
			git add . > /dev/null 2>&1
			git commit -m "$date" > /dev/null 2>&1
			git push > /dev/null 2>&1
			echo "Files backed up"
			;;
		"mkclass")
			mkdir ${workingdirectory}/${user_input[1]}
			mkdir ${workingdirectory}/${user_input[1]}/note
			mkdir ${workingdirectory}/${user_input[1]}/submit
			mkdir ${workingdirectory}/${user_input[1]}/material
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
			elif [[ "${user_input[1]}" == "home" ]]; then
				cd ${workingdirectory}
                	else
                        	cd ${workingdirectory}/${user_input[1]}
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
				rm -r ${workingdirectory}/trash
				mkdir ${workingdirectory}/trash
				echo "trash emptied"
                        else
				mv ${user_input[1]} ${workingdirectory}/trash
			fi

			;;
		"trash")
			
			if [[ ${user_input[1]} == "empty" ]]; then
                                rm -r ${workingdirectory}/trash
                                mkdir ${workingdirectory}/trash
                                echo "trash emptied"
			else
				ls ${workingdirectory}/trash
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
			;;
		
		"back")
			if [[ "${history[1]}" != "0" ]]; then
				cd ${history[1]}
				unset 'outputdate[0]'
				history=("${history[@]}" "0")
				history=("${history[@]}")
			else
				echo "Theres no back!"
			fi
			;;
		"schedule")
			
			#scheduleformat time<time<class<room
			
			source ${workingdirectory}/misc/setting/schedule.env
			weekday=$(date +"%A")
			date=$(date +"%m-%d-%Y")
			case "$weekday" in
                        	"Monday")
					point="mon"
                             		;;
                   		"Tuesday")
					point="tue"
                            		;;
                   		"Wensday")
					point="wed"
                        		;;            
                   		"Thursday")
					point="thu"
                   			;;
                   		"Friday")
					point="fri"
                    			;;
                     		"Saturday")
					point="sat"
                    			;;
        			"Sunday")
					point="sun"
                       			;;
                        esac
			if [[ "${rawinput}" == "schedule" ]]; then 
				IFS=">" read -ra outputdate <<< "${!point}"
				echo
                                echo "$weekday Morning | $date"


				   
                                for a in ${!outputdate[@]}; do
					IFS="<" read -ra parseinfo <<< "${outputdate[0]}"
                                	for b in ${!outputdate[@]}; do
                                        	IFS="<" read -ra parseinfo2 <<< "${outputdate[$b]}"
                                              	if [[ "${parseinfo[0]}" > "${parseinfo2[0]}" ]]; then
							tmp=${outputdate[$b]}
							unset 'outputdate[$b]'
                                          		outputdate=("${tmp}" "${outputdate[@]}")
                                             		outputdate=("${outputdate[@]}")	
                                               		break
                                          	fi
                         		done
                      		done
				for i in ${!outputdate[@]}; do  
   	                             	IFS="<" read -ra parseinfo <<< "${outputdate[$i]}"
                                        echo
                                        echo "${parseinfo[2]}"
                                        echo "${parseinfo[0]}-${parseinfo[1]} | ${parseinfo[3]}"
                                done
                                echo
			elif [[ ${user_input[1]} == "edit" ]]; then
				selection="Monday"
				while true; do
        				dir="Edit Menu"
        				read -p "${dir}: " rawinput
        				IFS=" " read -ra user_input <<< "$rawinput"
					case "${user_input[0]}" in
						"select")
							passthrough="${rawinput/select /}"
							if [[ ${rawinput} == "select" ]]; then
								echo "${selection}"
                        				elif [[ -z "$passthrough" ]]; then
                                				echo "No argument given"
                        				else
                                				case "${user_input[1]}" in
									"Monday" | "Tuesday" | "Wensday")
										selection="${user_input[1]}"
										;;
									"Thursday" | "Friday" | "Saturday" | "Sunday")
										selection="${user_input[1]}"
										;;
									*)
										echo "Not a valid day"
										;;
								esac
                        				fi
							;;
						"add")
							passthrough="${rawinput/add /}"
                                                        if [[ ${rawinput} == "add" ]]; then
                                                                echo "add format: time_1 time_2 class room"
                                                        else
								declare -g \
								"${point}+=${user_input[1]}<${user_input[2]}<${user_input[3]}<${user_input[4]}>"

								echo ${!point}
                                                        fi
                                                        ;;
							
						"edit")
							;;
						"delete")
							;;
						"exit")
							break
							;;
					esac
				done
			fi
			;;

		"help")
			echo "${helpstring}" 
			;;

        	*)
                	$rawinput
			;;

        esac

done
