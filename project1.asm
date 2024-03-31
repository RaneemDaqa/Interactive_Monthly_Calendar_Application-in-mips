.data
filename:
.asciiz "C:/Users/A To Z/Desktop/4/ARC Project 1/test.txt"

title:
.asciiz "Interactive Monthly Calendar Application:"
choice1:
.asciiz "\n\n1. View the calendar\n"
choice1_1:
.asciiz "\n1. View the calendar per day\n"
choice1_2:
.asciiz "2. View the calendar per sey of days\n"
choice1_3:
.asciiz "3. View the calendar per day for a slot of time\n"
choice2:
.asciiz "2. View Statistics\n"
choice2_1:
.asciiz "\n1. Number of lectures (in hours)\n"
choice2_2:
.asciiz "2. Number of office hours (in hours)\n"
choice2_3:
.asciiz "3. Number of meetings (in hours)\n"
choice2_4:
.asciiz "4. Average lectures per day\n"
choice2_5:
.asciiz "5. The ratio between total number of lectures and the total number of office hours\n"
choice3:
.asciiz "3. Add a new appointment\n"
choice4:
.asciiz "4. Delete an appointment\n"
choice5:
.asciiz "5. Exit\n"
enterchoice:
.asciiz "\nPlease Enter your choice: "
error:
.asciiz "Invalid input, try again...\n"
asknum:
.asciiz "\nEnter the day number: "
asksetnum:
.asciiz "\nEnter the set of days number: "
askstart:
.asciiz "\nEnter the start slot: "
askend:
.asciiz "\nEnter the end slot: "
asktype:
.asciiz "\nEnter the type (L: for a lecture, OH: for an office hour, and M: for a meeting): "
lectures:
.asciiz "\nThe number of lectures (in hours) is: "
officehours :
.asciiz "\nThe number of office hours  (in hours) is: "
average:
.asciiz "\nThe average lectures per day is: "
ratio:
.asciiz "\nThe ratio between total number of hours reserved for lectures and the total number of hours reserved OH is: "
meetings:
.asciiz "\nThe number of meetings (in hours) is: "
notfound:
.asciiz "There is no day with this number in the calender\n"
notfound2:
.asciiz "The hour entered is not an official working hour\n"
slotvalue: 
.asciiz "\nThe end of slot must be large than start of slot!\n"
typevalue: 
.asciiz "\nThe type must be L: for a lecture OR OH: for an office hour OR M: for a meeting only!"

enter_start_slot2:.asciiz "\nEnter start Slot:"
enter_end_slot2:.asciiz "\nEnter end Slot:"
newline:  .asciiz "\n"
type2: .asciiz "\nenter type:"
newtype :.asciiz "\nDO you want Enter new type?(y/n):"
buffer2:     .space  128     # Allocate space for the buffer (enough for two strings)
string:     .space  2      # Allocate space for the input string

error_msg_start:  .asciiz "\n\nError:Conflict in the time\n"
error_msg_end:  .asciiz "\n\nError:Conflict in the time\n"
error_msg_slot:  .asciiz "\nError:Conflict in the time\n"

asknum1: .asciiz "\nEnter the day number to search if the day exists or not in the calendar:"
asknum2 : .asciiz "\nEnter the day number to add to calendar:"
Updateday: .asciiz "\nThe day exist in calendar,do you want to update it?(y/n):"
ADD: .asciiz "\nWhat type do you want to added:(1.L 2.OH 3.M):"
update: .asciiz "\nWhat type do you want to update:(1.L 2.OH 3.M):"

input: .space 65536 #will hold the file input string
buffer: .space 256 #holding the information to view
x: .space 4 #holding the num of day
type: .space 4 #will hold the type value

.text
.globl main
main:
################################################ Menu starts here ####################################################
#printing the title
    li $v0, 4
    la $a0, title
    syscall

menu:
################################################ Read file starts here ####################################################
#open a file for reading
    li $v0, 13 # system call for open file
    la $a0, filename # file name
    li $a1, 0
    syscall

    move $s0, $v0 # save the file descriptor

# read from file
    li $v0, 14
    move $a0, $s0                  # file descriptor
    la $a1, input                  # address of input to which to read
    li $a2, 1024                   # hardcoded input length
    syscall

# Close the file 
    li $v0, 16
    move $a0, $s0
    syscall
################################################ Read file ends here ####################################################
    
#printing choice 1
    li $v0, 4
    la $a0, choice1
    syscall

#printing choice 2
    li $v0, 4
    la $a0, choice2
    syscall

#printing choice 3
    li $v0, 4
    la $a0, choice3
    syscall

#printing choice 4
    li $v0, 4
    la $a0, choice4
    syscall
    
#printing choice 5
    li $v0, 4
    la $a0, choice5
    syscall

#asking for the choice
    li $v0, 4
    la $a0, enterchoice
    syscall

#reading the choice from the user
    li $v0, 5
    syscall
    move $t3, $v0 #the readed number now in $t3

    beq $t3, 1, view_calender
    beq $t3, 2, view_statistics
    beq $t3, 3, add_appointment
    beq $t3, 4, delete_appointment
    beq $t3, 5, exit

#if the choice is not from 1 to 4
#print a messsage error
    li $v0, 4
    la $a0, error
    syscall

    j menu

################################################ view Calender ####################################################
view_calender:
# print choice 1
    li $v0, 4
    la $a0, choice1_1
    syscall

# print choice 2
    li $v0, 4
    la $a0, choice1_2
    syscall

# print choice 3
    li $v0, 4
    la $a0, choice1_3
    syscall

#asking for the choice
    li $v0, 4
    la $a0, enterchoice
    syscall

#reading the choice from the user
    li $v0, 5
    syscall
    move $t3, $v0 #the readed number now in $t3

    beq $t3, 1, viewperday
    beq $t3, 2, viewperset
    beq $t3, 3, viewperslot

#if the choice is not from 1 to 4, print a messsage error
    li $v0, 4
    la $a0, error
    syscall

    j view_calender

################################################ view Per Day ####################################################
viewperday:
#ask to enter the day number
    li $v0, 4
    la $a0, asknum
    syscall

#reading the number
    li $v0, 5
    syscall
    move $t3, $v0

    la $a1, input            # address of input to which to read
    la $a2, x                # Load the address of x into $a2
    la $a3, buffer           # Load the address into $a3

loop:
# Load a byte from the input
    lb $t0, ($a1)
    beq $t0, $zero, not_exist # End of file
    sb $t0, 0($a3)
    addi $a3, $a3, 1

    beq $t0, 10, newlinechar # end of line (newLine)
    addi $a1, $a1, 1

    beq $t0, 58, colonchar # colon char :
    sb $t0, 0($a2)
    addi $a2, $a2, 1

    j loop

colonchar:
    sb $zero, 0($a2)

    la $a0, x
    jal to_integer
    move $t2, $v1

    la $a0, x
    jal clear_string
    la $a2, x

#comparing with the entered num from user
    beq $t2, $t3, day_found
    j loop

newlinechar:
    addi $a1, $a1, 1
    la $a0, buffer
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $a2, x
    la $a3, buffer
    j loop

day_found:
    lb $t0, 0($a1)
    beq $t0, 10, done
    beq $t0, $zero, done
    sb $t0, 0($a3)
    addi $a3, $a3, 1
    addi $a1, $a1, 1
    j day_found

done:
    sb $zero, 0($a3)
#printing the info
    li $v0, 4
    la $a0, buffer
    syscall

#print a newLine char
    li $v0, 11
    li $a0, 10
    syscall

    la $a0, buffer
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string

    j menu

not_exist:
#printing the day number was not found
    li $v0, 4
    la $a0, notfound
    syscall

    j menu

################################################ view Per Set ####################################################
viewperset:
# Ask the user to enter the number of days in the set
    li $v0, 4
    la $a0, asksetnum
    syscall

# Read the number of days from the user
    li $v0, 5
    syscall

    move $t4, $v0 # Number of days in the set

set_loop:

#ask to enter the day number
    li $v0, 4
    la $a0, asknum
    syscall

#reading the number
    li $v0, 5
    syscall
    move $t3, $v0

    la $a1, input            # address of input to which to read
    la $a2, x                # Load the address of x into $a2
    la $a3, buffer           # Load the address into $a3

loop_2:
# Load a byte from the input
    lb $t0, ($a1)
    beq $t0, $zero, not_exist_2 # End of file
    sb $t0, 0($a3)
    addi $a3, $a3, 1

    beq $t0, 10, newlinechar_2 # end of line (newLine)
    addi $a1, $a1, 1

    beq $t0, 58, colonchar_2 # colon char :
    sb $t0, 0($a2)
    addi $a2, $a2, 1

    j loop_2

colonchar_2:
    sb $zero, 0($a2)

    la $a0, x
    jal to_integer
    move $t2, $v1

    la $a0, x
    jal clear_string
    la $a2, x

#comparing with the entered num from user
    beq $t2, $t3, day_found_2
    j loop_2

newlinechar_2:
    addi $a1, $a1, 1
    la $a0, buffer
    jal clear_string
    la $a2, x
    la $a3, buffer
    j loop_2

day_found_2:
    lb $t0, 0($a1)
    beq $t0, 10, done_2
    beq $t0, $zero, done_2
    sb $t0, 0($a3)
    addi $a3, $a3, 1
    addi $a1, $a1, 1
    j day_found_2

done_2:
    sb $zero, 0($a3)
#printing the info
    li $v0, 4
    la $a0, buffer
    syscall

#print a newLine char
    li $v0, 11
    li $a0, 10
    syscall

    la $a0, buffer
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string

    sub $t4, $t4, 1 # Decrement the set counter
    bnez $t4, set_loop
    beqz $t4, menu # If no more sets, return to the main menu

not_exist_2:
#printing the day number was not found
    li $v0, 4
    la $a0, notfound
    syscall
    j set_loop

################################################ view Per Slot ####################################################
viewperslot:
# Ask the user for the day
    li $v0, 4
    la $a0, asknum
    syscall

# Read the day from the user
    li $v0, 5
    syscall
    move $t3, $v0 # Day

    la $a1, input # address of input into $a1
    la $a2, x # Load the address of x into $a2
    la $a3, buffer # Load the address of buffer into $a3

loop_3:
# Load a byte from the input
    lb $t0, ($a1)
    beq $t0, $zero, not_exist_3 # End of file
    sb $t0, 0($a3)
    addi $a3, $a3, 1

    beq $t0, 10, newlinechar_3 # end of line (newLine)
    addi $a1, $a1, 1

    beq $t0, 58, colonchar_3 # colon char :
    sb $t0, 0($a2)
    addi $a2, $a2, 1

    j loop_3

colonchar_3:
    sb $zero, 0($a2)

    la $a0, x
    jal to_integer
    move $t2, $v1

    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $a2, x

    la $a0, buffer
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $a3, buffer

#comparing with the entered num from user
    beq $t2, $t3, day_found_3
    j loop_3

newlinechar_3:
    addi $a1, $a1, 1
    la $a0, buffer
    jal clear_string
    la $a2, x
    la $a3, buffer
    j loop_3

day_found_3:
    lb $t0, 0($a1)
    beq $t0, 10, done_3 # new line char '\n'
    beq $t0, $zero, done_3 # null terminator char '\0'
    sb $t0, 0($a3)
    addi $a3, $a3, 1
    addi $a1, $a1, 1
    j day_found_3

done_3:
    sb $zero, 0($a3)

#printing the info
    li $v0, 4
    la $a0, buffer
    syscall

#print a newLine char
    li $v0, 11
    li $a0, 10
    syscall

# Ask the user for the start time slot
    jal enter_start_slot
    
    jal convert_hour
    move $t4, $v0 # Start time slot

# Ask the user for the end time slot
    jal enter_end_slot

    jal convert_hour
    move $t5, $v0 # End time slot
    
    bge $t4, $t5, periodcondition

    la $a2, x # Load the address of x into $a2
    la $a3, buffer # Load the address of buffer into $a3
    
loop_slot:
    # Load a byte from the buffer
    lb $t0, ($a3)
    beq $t0, $zero, end_of_buffer # end of string then jump to menu
    addi $a3, $a3, 1

    beq $t0, 44, comma_char_label # The comma char ',' has a decimal value of 44.  
	
    beq $t0, 45, hyphen_char_label # The hyphen char '-' has a decimal value of 45.
    beq $t0, 32, space_char_label # The space char ' ' has a decimal value of 32.
  	
    sb $t0, 0($a2)
    addi $a2, $a2, 1 

    j loop_slot

comma_char_label:
    sb $zero, 0($a2)

    la $s6, x
    
    blt $t2, $t4, case1
    beq $t2, $t4, case2
    bgt $t2, $t4, case3

case1:
    ble $t3, $t4, case1_1
    bgt $t3, $t4, case1_2

case1_1:
    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot

case1_2:
    ble $t3, $t5, case1_2_1
    bgt $t3, $t5, case1_2_2

case1_2_1:
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t3
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t3, $v0

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot

case1_2_2:
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot

case2:
    ble $t3, $t5, case2_1
    bgt $t3, $t5, case2_2

case2_1:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t3
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t3, $v0

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot

case2_2:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot

case3:
    bge $t2, $t5, case3_1
    blt $t2, $t5, case3_2

case3_1:
    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot

case3_2:
    bge $t3, $t5, case3_2_1
    blt $t3, $t5, case3_2_2

case3_2_1:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot

case3_2_2:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t3
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t3, $v0

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j loop_slot
#######################################################################    
end_of_buffer:
    sb $zero, 0($a2)

    la $s6, x

    blt $t2, $t4, case1a
    beq $t2, $t4, case2a
    bgt $t2, $t4, case3a

case1a:
    ble $t3, $t4, case1_1a
    bgt $t3, $t4, case1_2a

case1_1a:
    la $a0,x
    jal clear_string
    la $a2, x

    j menu

case1_2a:
    ble $t3, $t5, case1_2_1a
    bgt $t3, $t5, case1_2_2a

case1_2_1a:
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t3
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t3, $v0

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j menu

case1_2_2a:
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j menu

case2a:
    ble $t3, $t5, case2_1a
    bgt $t3, $t5, case2_2a

case2_1a:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t3
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t3, $v0

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j menu

case2_2a:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j menu
    
case3a:
    bge $t2, $t5, case3_1a
    blt $t2, $t5, case3_2a

case3_1a:
    la $a0,x
    jal clear_string
    la $a2, x

    j menu

case3_2a:
    bge $t3, $t5, case3_2_1a
    blt $t3, $t5, case3_2_2a

case3_2_1a:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j menu

case3_2_2a:
    move $v0, $t2
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t2, $v0

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 11
    li $a0, 45
    syscall

    move $v0, $t3
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t3, $v0

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    li $v0, 4
    la $a0, x
    syscall

    li $v0, 11
    move $a0, $t0
    syscall

    la $a0,x
    jal clear_string
    la $a2, x

    j menu

space_char_label:
    sb $zero, 0($a2)
  		
    la $a0,x
    jal to_integer
    move $v0, $v1

    jal convert_hour # to convert hour value from 12 hour system to 24 hour system
    move $t3, $v0
  		
    la $a0,x
    jal clear_string
    la $a2, x
   
    j loop_slot

hyphen_char_label:
    sb $zero, 0($a2)
  		
    la $a0,x
    jal to_integer
    move $v0, $v1

    jal convert_hour # to convert hour value from 12 hour system to 24 hour system
    move $t2, $v0
  		
    la $a0,x
    jal clear_string
    la $a2, x
    
    j loop_slot  

not_exist_3:
#printing the day number was not found
    li $v0, 4
    la $a0, notfound
    syscall

    j viewperslot 
    
################################################ view Statistics ####################################################
view_statistics:
	la $a1, input        # address of input to which to read
	la $a2, x 	     # Load the address of x into $a2
	
	li $s1, 0 # Initialize number of lectures (in hours) to 0
	li $s2, 0 # Initialize number of OH (in hours) to 0
	li $s3, 0 # Initialize number of meetings (in hours) to 0

loop_4:
	# Load a byte from the input
	lb $t0, ($a1)
	addi $a1, $a1, 1
	
	beq $t0, 58, colon_char_4 # colon char ':'
	
	beq $t0, 45, start_value # hyphen  char '-'
  	beq $t0, 32, end_value # space char ' '
  	
  	sb $t0, 0($a2)
  	addi $a2, $a2, 1
  	
  	beq $t0, $zero, end_of_calendar_4 # end of input '\0'
  	beq $t0, 10, comma_or_newline # new line char '\n'    
  	beq $t0, 44, comma_or_newline # comma char ','    

  	j loop_4                

start_value: 
       sb $zero, 0($a2)
  		
  	la $a0,x
  	jal to_integer
  	move $v0, $v1

        jal convert_hour # to convert hour value from 12 hour system to 24 hour system
  	move $t6, $v0
  		
  	la $a0,x
  	jal clear_string
	la $a2, x

  	j loop_4
  	
end_value: 
       sb $zero, 0($a2)
  		
  	la $a0,x
  	jal to_integer
  	move $v0, $v1

        jal convert_hour # to convert hour value from 12 hour system to 24 hour system
  	move $t7, $v0
  	
  	sub $t7, $t7, $t6
  		
  	la $a0,x
  	jal clear_string
	la $a2, x

  	j loop_4
  	
colon_char_4: 
       sb $zero, 0($a2)
  		
  	la $a0,x
  	jal clear_string
	la $a2, x

  	j loop_4

comma_or_newline:
    sb $zero, 0($a2)
    
    la $t1, x
    lb $t2, ($t1)
    li $t3, 'L'
    beq $t2, $t3, numberoflectures
    li $t3, 'O'
    beq $t2, $t3, numberofofficehours
    li $t3, 'M'
    beq $t2, $t3, numberofmeetings
    
    j loop_4

numberoflectures:
    add $s1, $s1, $t7
    
    la $a0,x
    jal clear_string
    la $a2, x
    
    j loop_4
    
numberofofficehours:
    add $s2, $s2, $t7
    
    la $a0,x
    jal clear_string
    la $a2, x
    
    j loop_4
    
numberofmeetings:   
    add $s3, $s3, $t7
    
    la $a0,x
    jal clear_string
    la $a2, x
    
    j loop_4

end_of_calendar_4:
    sb $zero, 0($a2)

    la $t1, x
    
    la $a0,x
    jal clear_string
    la $a2, x
    
    jal counter
    j read_choice

counter:
    lb $t2, ($t1)
    li $t3, 'L'
    beq $t2, $t3, numberoflectures2
    li $t3, 'O'
    beq $t2, $t3, numberofofficehours2
    li $t3, 'M'
    beq $t2, $t3, numberofmeetings2
    
numberoflectures2:
    add $s1, $s1, $t7
    jr $ra
    
numberofofficehours2:
    add $s2, $s2, $t7
    jr $ra
    
numberofmeetings2:
    add $s3, $s3, $t7
    jr $ra
    
read_choice:
# print choice 1
    li $v0, 4
    la $a0, choice2_1
    syscall

# print choice 2
    li $v0, 4
    la $a0, choice2_2
    syscall

# print choice 3
    li $v0, 4
    la $a0, choice2_3
    syscall

# print choice 4
    li $v0, 4
    la $a0, choice2_4
    syscall

# print choice 5
    li $v0, 4
    la $a0, choice2_5
    syscall

#asking for the choice
    li $v0, 4
    la $a0, enterchoice
    syscall

#reading the choice from the user
    li $v0, 5
    syscall
    move $t3, $v0 #the readed number now in $t3

    beq $t3, 1, number_of_lectures
    beq $t3, 2, number_of_office_hours
    beq $t3, 3, number_of_meetings
    beq $t3, 4, average_lectures_per_day
    beq $t3, 5, ratio_between_lectures_and_office_hours
    
    #if the choice is not from 1 to 5, print a messsage error
    li $v0, 4
    la $a0, error
    syscall

    j view_statistics

################################################ Number Of Lectures ####################################################
number_of_lectures:
#printing number of lectures
    li $v0, 4
    la $a0, lectures
    syscall
    
    li $v0, 1
    move $a0, $s1
    syscall
    
    j menu
################################################ Number Of Office_Hours ####################################################
number_of_office_hours:
#printing number of office hours
    li $v0, 4
    la $a0, officehours
    syscall
    
    li $v0, 1
    move $a0, $s2
    syscall
    
    j menu
################################################ Number Of Meetings ####################################################
number_of_meetings:
#printing number of meetings
    li $v0, 4
    la $a0, meetings
    syscall
    
    li $v0, 1
    move $a0, $s3
    syscall
    
    j menu
################################################ Average Lectures Per Day ####################################################
average_lectures_per_day:  
    la $a1, input              # Load the address of input into $a2
    # Count the number of lines
    li   $s4, 0                # Initialize the line count to 0
    
countLoop:
    lb $t0, ($a1)             # Load a byte from the input
    beq $t0, $zero, calculate_average # Calculate the average if the null terminator is reached
    beq $t0, 10, newlineChar  # Check for newline character
    addi $a1, $a1, 1           # Increment the input pointer
    j countLoop                # Repeat until the null terminator is reached

newlineChar:
    addi $s4, $s4, 1           # Increment the line count
    addi $a1, $a1, 1           # Increment the input pointer
    j countLoop                # Repeat until the null terminator is reached

calculate_average:
#printing average
    li $v0, 4
    la $a0, average
    syscall
    
    li $t0, 0
    li $t1, 0
    
    addi   $t0, $s1, 0               # Initialize total number of hours reserved for lectures
    addi   $t1, $s4, 1               # Initialize total number of days 
    
    jal div_float
    j menu

################################################ Ratio Between Lectures And Office Hours: ####################################################
ratio_between_lectures_and_office_hours:
#printing ratio
    li $v0, 4
    la $a0, ratio
    syscall
    
    li $t0, 0
    li $t1, 0
    
    addi   $t0, $s1, 0               # Initialize total number of hours reserved for lectures
    addi   $t1, $s2, 0               # Initialize total number of hours reserved for office hours             

    jal div_float
    j menu


################################################ Add a new Appointment ####################################################
add_appointment:
    j viewperday2
    
ADD1:  
   # Prompt user to enter the day
    li $v0, 4           # System call for print_str
    la $a0, asknum2
    syscall

    # Read the day string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall
    
     # Copy the day string to the buffer
    la $a0, string      # Load the address of the input string
    la $a1, buffer2     # Load the address of the buffer
    jal copy_string     # Jump to the copy_string subroutine
   

    # Properly terminate the buffer
    li $t7, 58  # :
    sb $t7, 0($a1)      # Null-terminate the buffer
    addi $t9, $a1, 1

read_loop:
     #asking for the choice
    li $v0, 4
    la $a0, ADD
    syscall

    #reading the choice from the user
    li $v0, 5
    syscall
    move $t3, $v0 #the readed number now in $t3

    beq $t3,1, L
    beq $t3,2, OH 
    beq $t3,3, M
    
    li $v0, 4
    la $a0, error
    syscall
    j read_loop

L:
     # Prompt user to enter the first byte
    li $v0, 4           # System call for print_str
    la $a0, enter_start_slot2
    syscall

    # Read string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall
    

    jal convert_string_to_int
    move $a0, $v0        # Save the result in $t3
    li $v0, 1           # System call code for print integer
    syscall
    
    blt $a0,8,not_Valid3
    bgt $a0,17,not_Valid3
    
    move $t5,$a0
 
     # Copy the  string to the buffer
     la $a0, string      # Load the address of the input string
     move $a1,  $t9      # Load the address of the buffer
     jal copy_string     # Jump to the copy_string subroutine
    
     li $t7,45# -
    # Properly terminate the buffer
    sb $t7, 0($a1)    # Null-terminate the buffer
    addi $t9,$a1, 1
  
    # Prompt user to enter the second byte
    li $v0, 4           # System call for print_str
    la $a0, enter_end_slot2
    syscall


      # Read the  string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall
    
    jal convert_string_to_int
    move $a0, $v0        # Save the result in $t3
    li $v0, 1           # System call code for print integer
    syscall
    
    blt $a0,8,not_Valid3
    bgt $a0,17,not_Valid3
    
    move $t6,$a0

    blt $t6,$t5,not_Valid3
    
      # Copy the  string to the buffer
    la $a0, string      # Load the address of the input string
    move $a1,  $t9      # Load the address of the buffer
    jal copy_string     # Jump to the copy_string subroutine
    
     li $t7,32 
    # Properly terminate the buffer
    sb $t7, 0($a1)    # Null-terminate the buffer
    addi $t9,$a1, 1
    
     # Prompt user to enter a character
    li $v0, 4           # System call for print_str
    la $a0,type2
    syscall

     # Read the  string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall

      # Copy the string to the buffer
    la $a0, string      # Load the address of the input string
    move $a1,  $t9      # Load the address of the buffer
    jal copy_string     # Jump to the copy_string subroutine
    
    
    # Ask user if they want to enter another byte
    li $v0, 4           # System call for print_str
    la $a0, newtype     # load address of newline string
    syscall
    
      # Read the string from the user
    li $v0, 12           # System call code for read_str
    syscall
    
     # Check if the user wants to enter another byte
    beq $v0, 121,comma2 # ASCII value for 'y', continue the loop if 'y'
    j printtofile
    
comma2:
     li $t7,44 # : 
    # Properly terminate the buffer
    sb $t7, 0($a1)    # Null-terminate the buffer
    addi $t9,$a1, 1
    j read_loop
    
OH:
  # Prompt user to enter the first byte
    li $v0, 4           # System call for print_str
    la $a0, enter_start_slot2
    syscall

    # Read string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall

    jal convert_string_to_int
    move $a0, $v0        # 
    li $v0, 1           # System call code for print integer
    syscall
    
    blt $a0,8,not_Valid3
    bgt $a0,17,not_Valid3
    move $t5,$a0
    
   blt $t5,$t6,not_Valid3

  
     # Copy the  string to the buffer
     la $a0, string      # Load the address of the input string
     move $a1,  $t9      # Load the address of the buffer
     jal copy_string     # Jump to the copy_string subroutine
    
     li $t7,45# -
    # Properly terminate the buffer
    sb $t7, 0($a1)    # Null-terminate the buffer
    addi $t9,$a1, 1
  
    # Prompt user to enter the second byte
    li $v0, 4           # System call for print_str
    la $a0, enter_end_slot2
    syscall


      # Read the  string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall
    
    jal convert_string_to_int
    move $a0, $v0        # Save the result in $t3
    li $v0, 1           # System call code for print integer
    syscall
    
    blt $a0,8,not_Valid3
    bgt $a0,17,not_Valid3
    
    move $t6,$a0

    blt $t6,$t5,not_Valid3
    

      # Copy the  string to the buffer
    la $a0, string      # Load the address of the input string
    move $a1,  $t9      # Load the address of the buffer
    jal copy_string     # Jump to the copy_string subroutine
    
   
    li $t7,32 
    # Properly terminate the buffer
    sb $t7, 0($a1)    # Null-terminate the buffer
    addi $t9,$a1, 1
    
    
     # Prompt user to enter a character
    li $v0, 4           # System call for print_str
    la $a0,type2
    syscall

     # Read the  string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall

      # Copy the string to the buffer
    la $a0, string      # Load the address of the input string
    move $a1,  $t9      # Load the address of the buffer
    jal copy_string     # Jump to the copy_string subroutine
    
    # Ask user if they want to enter another byte
    li $v0, 4           # System call for print_str
    la $a0, newtype     # load address of newline string
    syscall
    
      # Read the string from the user
    li $v0, 12           # System call code for read_str
    syscall
    
     # Check if the user wants to enter another byte
    beq $v0, 121,comma2 # ASCII value for 'y', continue the loop if 'y'
    
    j printtofile
M:
# Prompt user to enter the first byte
    li $v0, 4           # System call for print_str
    la $a0, enter_start_slot2
    syscall

    # Read string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall


    jal convert_string_to_int
    move $a0, $v0        # 
    li $v0, 1           # System call code for print integer
    syscall
    
    blt $a0,8,not_Valid3
    bgt $a0,17,not_Valid3
    
    move $t5,$a0
    
    blt $t5,$t6,not_Valid3

  
     # Copy the  string to the buffer
     la $a0, string      # Load the address of the input string
     move $a1,  $t9      # Load the address of the buffer
     jal copy_string     # Jump to the copy_string subroutine
    
     li $t7,45# -
    # Properly terminate the buffer
    sb $t7, 0($a1)    # Null-terminate the buffer
    addi $t9,$a1, 1
  
    # Prompt user to enter the second byte
    li $v0, 4           # System call for print_str
    la $a0, enter_end_slot2
    syscall


      # Read the  string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall
    
    jal convert_string_to_int
    move $a0, $v0        # Save the result in $t3
    li $v0, 1           # System call code for print integer
    syscall
    
    blt $a0,8,not_Valid3
    bgt $a0,17,not_Valid3
    
    move $t6,$a0

    blt $t6,$t5,not_Valid3

      # Copy the  string to the buffer
    la $a0, string      # Load the address of the input string
    move $a1,  $t9      # Load the address of the buffer
    jal copy_string     # Jump to the copy_string subroutine
    
     li $t7,32 
    # Properly terminate the buffer
    sb $t7, 0($a1)    # Null-terminate the buffer
    addi $t9,$a1, 1
    
    
     # Prompt user to enter a character
    li $v0, 4           # System call for print_str
    la $a0,type2
    syscall

     # Read the  string from the user
    li $v0, 8           # System call code for read_str
    la $a0, string      # Load the address of the input string
    li $a1, 64          # Specify the maximum number of characters to read
    syscall

      # Copy the string to the buffer
    la $a0, string      # Load the address of the input string
    move $a1,  $t9      # Load the address of the buffer
    jal copy_string     # Jump to the copy_string subroutine
    
    # Ask user if they want to enter another byte
    li $v0, 4           # System call for print_str
    la $a0, newtype     # load address of newline string
    syscall
    
      # Read the string from the user
    li $v0, 12           # System call code for read_str
    syscall
    
     # Check if the user wants to enter another byte
    beq $v0, 121,comma2 # ASCII value for 'y', continue the loop if 'y'
    
    j printtofile
    
  
printtofile:
    li $v0, 4           # System call code for print_str
    la $a0, buffer2     # Load the address of the buffer
    syscall
    
    # Open file for appending (syscall 13)
    li $v0, 13                   # System call code for open
    la $a0, filename             # Load address of the filename
    li $a1, 9                    # Open for appending
    li $a2, 0                    # File mode 
    syscall                      # Perform the system call

    move $s0, $v0                # Save the file descriptor
        
   # Write newline character to file
   li $v0, 15                   # System call code for write
   move $a0, $s0                # File descriptor
   la $a1, newline              # Load address of the newline character
   li $a2, 1                    # Length of the newline character
   syscall                      # Perform the system call

   # Write string to file (syscall 15)
   li $v0, 15                   # System call code for write
   move $a0, $s0                # File descriptor
   la $a1, buffer2              # Load address of the string
   li $a2, 100                   # Length of the string to write
   syscall                      # Perform the system call

  # Close the file (syscall 16)
  li $v0, 16                   # System call code for close
  move $a0, $s0                # File descriptor
  syscall                      # Perform the system call

  j menu

        
copy_string:
    copy_loop:
        lb $t0, 0($a0)   # Load a byte from the input string
        beqz $t0, copy_done   # If the byte is null (end of string), exit loop

        # Check if the byte is a newline character
        li $t1, 10   # ASCII code for newline character
        beq $t0, $t1, skip_newline   # If the byte is a newline character, skip copying

        sb $t0, 0($a1)   # Store the byte into the buffer
        addi $a1, $a1, 1   # Move to the next byte in the buffer

        skip_newline:
        addi $a0, $a0, 1   # Move to the next byte in the input string
        j copy_loop   # Repeat the loop

    copy_done:
    sb $zero, 0($a1)   # Null-terminate the buffer
    jr $ra   # Return from subroutine


convert_string_to_int:
        # Initialize $v0 to store the result
        li $v0, 0
    convert_loop:
         # Load the ASCII code of the current character into $t1
        lb $t1, 0($a0)
        beq $t1,10, end_convert # if the string end with new line character
          # Extract the lower 4 bits (half-byte)
        beqz $t1, end_convert
        andi $t1, $t1, 0x0F
        # Check for the null terminator (end of string)
        # Multiply the current result by 10
        mulu $v0, $v0, 10

        # Add the converted digit to the result
        add $v0, $v0, $t1
        # Move to the next character in the string
        addi $a0, $a0, 1
        # Repeat the loop
        j convert_loop

    end_convert:
     # Check if $a0 is one of the specified values, and add 12 if true
    li $t3, 1
    beq $v0, $t3, add_122
    li $t3, 2
    beq $v0, $t3, add_122
    li $t3, 3
    beq $v0, $t3, add_122
    li $t3, 4
    beq $v0, $t3, add_122
    li $t3, 5
    beq $v0, $t3, add_122

    j end_addition

add_122:
    li $t4, 12
    add $v0, $v0, $t4
    j end_addition

end_addition:
    jr $ra

       
        
not_Valid1:
    # Clear the buffer2
    la $t8, buffer2   # Load the address of buffer2 into $t8
    li $t0, 0         # Initialize $t0 to 0

    clear_buffer_loop1:
        sb $t0, 0($t8)  # Store 0 in the buffer
        addi $t8, $t8, 1  # Move to the next byte in the buffer
        bnez $t0, clear_buffer_loop1  # Repeat until the buffer is cleared

    # Print the error message
    li $v0, 4        # System call for print_str
    la $a0, error_msg_start   # Load the address of the error message
    syscall          # Make system call

    # Jump to add_appointment
    j add_appointment
    
not_Valid2:
     # Clear the buffer2
    la $t8, buffer2   # Load the address of buffer2 into $t8
    li $t0, 0         # Initialize $t0 to 0

    clear_buffer_loop2:
        sb $t0, 0($t8)  # Store 0 in the buffer
        addi $t8, $t8, 1  # Move to the next byte in the buffer
        bnez $t0, clear_buffer_loop2  # Repeat until the buffer is cleared

    # Jump to add_appointment

    # Print the error message
    li $v0, 4        # System call for print_str
    la $a0, error_msg_end  # Load the address of the error message
    syscall          # Make system call

    j add_appointment
 
not_Valid3:
 # Clear the buffer2
    la $t8, buffer2   # Load the address of buffer2 into $t8
    li $t0, 0         # Initialize $t0 to 0

    clear_buffer_loop3:
        sb $t0, 0($t8)  # Store 0 in the buffer
        addi $t8, $t8, 1  # Move to the next byte in the buffer
        bnez $t0, clear_buffer_loop3 # Repeat until the buffer is cleared

    # Jump to add_appointment

    # Print the error message
    li $v0, 4        # System call for print_str
    la $a0, error_msg_slot # Load the address of the error message
    syscall          # Make system call

    j add_appointment
 

################################################ view Per day####################################################
viewperday2:
#ask to enter the day number
    li $v0, 4
    la $a0, asknum1
    syscall

#reading the number
    li $v0, 5
    syscall
    move $t3, $v0

    la $a1, input           # address of input to which to read
    la $a2, x                # Load the address of x into $a2
    la $a3, buffer          # Load the address into $a3

loop_f:
# Load a byte from the input
    lb $t0, ($a1)
    beq $t0, $zero, not_exist_f # End of file
    sb $t0, 0($a3)
    addi $a3, $a3, 1

    beq $t0, 10, newlinechar_f # end of line (newLine)
    addi $a1, $a1, 1

    beq $t0, 58, colonchar_f # colon char :
    sb $t0, 0($a2)
    addi $a2, $a2, 1

    j loop_f

colonchar_f:
    sb $zero, 0($a2)

    la $a0, x
    jal to_integer
    move $t2, $v1

    la $a0, x
    jal clear_string
    la $a2, x

#comparing with the entered num from user
    bne $t2, $t3, day_found_f
    j loop_f

newlinechar_f:
    addi $a1, $a1, 1
    la $a0, buffer
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $a2, x
    la $a3, buffer
    j loop_f

day_found_f:
   lb $t0, 0($a1)
    beq $t0, 10,done_f
    beq $t0, $zero, done_f
    sb $t0, 0($a3)
    addi $a3, $a3, 1
    addi $a1, $a1, 1
    j day_found_f
    
done_f:
    sb $zero, 0($a3)
#printing the info
    li $v0, 4
    la $a0, buffer
    syscall

#print a newLine char
    li $v0, 11
    li $a0, 10
    syscall


    #j printtofile2
    
    la $a0, buffer
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string

     j loop_f

not_exist_f:
    move $v1, $t3
    j ADD1
    
    

printtofile2:
     # Print to console
    li $v0, 4           # System call code for print_str
    la $a0, buffer      # Load the address of the buffer
    syscall

    # Open file for appending (syscall 13)
    li $v0, 13                   # System call code for open
    la $a0, filename             # Load address of the filename
    li $a1, 9                    # Open for appending
    li $a2, 0                    # File mode 
    syscall                      # Perform the system call

    move $s0, $v0                # Save the file descriptor

    # Write newline character to file
    li $v0, 15                   # System call code for write
    move $a0, $s0                # File descriptor
    la $a1, newline              # Load address of the newline character
    li $a2, 1                    # Length of the newline character
    syscall                      # Perform the system call

    # Write string to file (syscall 15)
    li $v0, 15                   # System call code for write
    move $a0, $s0                # File descriptor
    la $a1,buffer              # Load address of the string
    li $a2, 100                  # Length of the string to write
    syscall                      # Perform the system call

    # Close the file (syscall 16)
    li $v0, 16                   # System call code for close
    move $a0, $s0                # File descriptor
    syscall                      # Perform the system call

    jr $ra
        

################################################ Delete Appointment ####################################################
delete_appointment:
# flag if the day number exist in the calendar or not, here by default $s1 declared '0' means the day number not exist in the calendar
    li $s1, 0
    
# Ask the user for the day
    li $v0, 4
    la $a0, asknum
    syscall

# Read the day from the user
    li $v0, 5
    syscall
    move $t3, $v0 # Day

    la $s3, input # address of input into $s3
    la $s4, x # Load the address of x into $s4
    la $s5, buffer # Load the address of buffer into $s5

loop_5:
# Load a byte from the input
    lb $t0, ($s3)
    beq $t0, $zero, not_exist_5 # end of file '\0'

    addi $s3, $s3, 1  
    beq $t0, 10, newline_comma_char # new line
    beq $t0, 44, newline_comma_char # comma char   
  	
    beq $t0, 32, space_hypen_char # space char ' '
    beq $t0, 45, space_hypen_char # hypen char  '-'
  	       
    beq $t0, 58, colonchar_5 # colon char :  
  
    sb $t0, 0($s4)
    addi $s4, $s4, 1        

    j loop_5

colonchar_5:
    sb $zero, 0($s4)

    la $a0, x
    jal to_integer
    move $t2, $v1

    la $t9, x
    jal copyString   # Jump to the copyString subroutine

    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    bne $t2, $t3, day_number_not_found
    beq $t2, $t3, day_number_found

day_number_found:
# flag if the day number exist in the calendar or not, here load Immediate: to set $s1 to '0' means the day number exist in the calendar
    li $s1, 1

slot_2:   
# Ask the user for the start time slot
    jal enter_start_slot
    
    jal convert_hour_2
    move $t4, $v0 # Start time slot

# Ask the user for the end time slot
    jal enter_end_slot

    jal convert_hour_2
    move $t5, $v0 # End time slot
    
    bge $t4, $t5, periodcondition_2
    
# Ask the user for the type value
    li $v0, 4
    la $a0, asktype
    syscall

# Read the type from the user
    li $v0, 8               # System call code for read_str
    la $a0, type          # Load address of the buffer
    li $a1, 4              # Maximum number of characters to read
    syscall
    
    lb $s2, 0($a0)
     
    beq $s2, 'L', loop_6
    beq $s2, 'l', convert_to_upper_case
    beq $s2, 'O', loop_6
    beq $s2, 'o', convert_to_upper_case
    beq $s2, 'M', loop_6
    beq $s2, 'm', convert_to_upper_case
    
    j typecondition
    
convert_to_upper_case:
    subi $s2, $s2, 32
    j loop_6
     
loop_6:
# Load a byte from the input
    lb $t0, ($s3)
    beq $t0, $zero, null_terminator_char # end of file '\0'
    beq $t0, 10, new_line_char # end of line '\n'

    addi $s3, $s3, 1   
    beq $t0, 44, comma_char # comma char 
  	
    beq $t0, 32, space # space char ' '
    beq $t0, 45, hypen # hypen char  '-'
  
    sb $t0, 0($s4)
    addi $s4, $s4, 1    

    j loop_6
  
#######################################################################3	
comma_char:
    sb $zero, 0($s4)

    la $s6, x
    
    lb $s7, 0($s6)
    
    beq $s7, $s2, same_type
    bne $s7, $s2, not_same_type
    
same_type:
    blt $t6, $t4, less_than
    bgt $t6, $t4, greater_than
    beq $t6, $t4, equal

less_than:
    blt $t7, $t4, end_of_file_less_than_or_equal_start_of_slot
    bgt $t7, $t4, end_of_file_greater_than_start_of_slot
    beq $t7, $t4, end_of_file_less_than_or_equal_start_of_slot
 
end_of_file_greater_than_start_of_slot:
    blt $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_4
    bgt $t7, $t5, end_of_file_greater_than_end_of_slot_4
    beq $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_4

end_of_file_greater_than_end_of_slot_4:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
    
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h
    bne $s7, 'O', continue_in_buffer

add_h: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer:
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0
    
    la $s4,x 
    move $a0,$t5
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
    
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_2
    bne $s7, 'O', continue_in_buffer_2

add_h_2: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_2:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j loop_6
      
end_of_file_less_than_or_equal_end_of_slot_4:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
    
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
    
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_3
    bne $s7, 'O', continue_in_buffer_3

add_h_3: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_3:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j loop_6
    
end_of_file_less_than_or_equal_start_of_slot:  
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
    
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
    
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_4
    bne $s7, 'O', continue_in_buffer_4

add_h_4: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_4:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j loop_6
    
equal:
    blt $t7, $t5, end_of_file_less_than_or_equal_end_of_slot
    bgt $t7, $t5, end_of_file_greater_than_end_of_slot
    beq $t7, $t5, end_of_file_less_than_or_equal_end_of_slot

end_of_file_less_than_or_equal_end_of_slot:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j loop_6

end_of_file_greater_than_end_of_slot:
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
    
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char   
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
    
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_5
    bne $s7, 'O', continue_in_buffer_5

add_h_5: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_5:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j loop_6

greater_than:
    blt $t7, $t5, eee
    bgt $t7, $t5, qqq
    beq $t7, $t5, xxx

qqq:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char    
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
    
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_21
    bne $s7, 'O', continue_in_buffer_21

add_h_21: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_21:    
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j loop_6
      
eee:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j loop_6

xxx:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j loop_6
         
not_same_type:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
    
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char   
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
    
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1

    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_6
    bne $s7, 'O', continue_in_buffer_6

add_h_6: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_6:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j loop_6

#######################################################################
new_line_char:
    sb $zero, 0($s4)

    la $s6, x
    
    lb $s7, 0($s6)
    
    beq $s7, $s2, same_type_2
    bne $s7, $s2, not_same_type_2
    
same_type_2:
    blt $t6, $t4, less_than_2
    bgt $t6, $t4, greater_than_2
    beq $t6, $t4, equal_2

less_than_2:
    blt $t7, $t4, end_of_file_less_than_or_equal_start_of_slot_2
    bgt $t7, $t4, end_of_file_greater_than_start_of_slot_2
    beq $t7, $t4, end_of_file_less_than_or_equal_start_of_slot_2
 
end_of_file_greater_than_start_of_slot_2:
    blt $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_5
    bgt $t7, $t5, end_of_file_greater_than_end_of_slot_5
    beq $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_5

end_of_file_greater_than_end_of_slot_5:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
    
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char   
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
    
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char    
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_7
    bne $s7, 'O', continue_in_buffer_7

add_h_7: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_7:
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0
    
    la $s4,x 
    move $a0,$t5
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char   
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
  
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
 
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_8
    bne $s7, 'O', continue_in_buffer_8

add_h_8: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_8:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
   
    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j loop_5
      
end_of_file_less_than_or_equal_end_of_slot_5:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
  
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char   
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
   
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char    
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
   
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_9
    bne $s7, 'O', continue_in_buffer_9

add_h_9: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_9:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
   
    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j loop_5
    
end_of_file_less_than_or_equal_start_of_slot_2:  
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
   
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char   
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
    
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_10
    bne $s7, 'O', continue_in_buffer_10

add_h_10: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_10:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j loop_5
    
equal_2:
    blt $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_2
    bgt $t7, $t5, end_of_file_greater_than_end_of_slot_2
    beq $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_2

end_of_file_less_than_or_equal_end_of_slot_2:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j loop_5

end_of_file_greater_than_end_of_slot_2:
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
    
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char 
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char  
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
   
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_11
    bne $s7, 'O', continue_in_buffer_11

add_h_11: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_11:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
   
    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j loop_5

greater_than_2:
    blt $t7, $t5, eee_2
    bgt $t7, $t5, qqq_2
    beq $t7, $t5, xxx_2

qqq_2:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char  
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
   
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char 
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
  
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_22
    bne $s7, 'O', continue_in_buffer_22

add_h_22: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_22:  
    li $t8, 10
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j loop_5
      
eee_2:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j loop_5

xxx_2:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j loop_5
         
not_same_type_2:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0

    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1

    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_12
    bne $s7, 'O', continue_in_buffer_12

add_h_12: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_12:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j loop_5
#######################################################################
null_terminator_char:
    sb $zero, 0($s4)

    la $s6, x
    
    lb $s7, 0($s6)
    
    beq $s7, $s2, same_type_3
    bne $s7, $s2, not_same_type_3
    
same_type_3:
    blt $t6, $t4, less_than_3
    bgt $t6, $t4, greater_than_3
    beq $t6, $t4, equal_3

less_than_3:
    blt $t7, $t4, end_of_file_less_than_or_equal_start_of_slot_3
    bgt $t7, $t4, end_of_file_greater_than_start_of_slot_3
    beq $t7, $t4, end_of_file_less_than_or_equal_start_of_slot_3
 
end_of_file_greater_than_start_of_slot_3:
    blt $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_6
    bgt $t7, $t5, end_of_file_greater_than_end_of_slot_6
    beq $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_6

end_of_file_greater_than_end_of_slot_6:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char 
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
  
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char 
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1

    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_13
    bne $s7, 'O', continue_in_buffer_13

add_h_13: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_13:
    li $t8, 44
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t5
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t5, $v0
  
    la $s4,x 
    move $a0,$t5
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0

    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
 
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_14
    bne $s7, 'O', continue_in_buffer_14

add_h_14: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_14:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j Write_to_file
      
end_of_file_less_than_or_equal_end_of_slot_6:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0

    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
 
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_15
    bne $s7, 'O', continue_in_buffer_15

add_h_15: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_15:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j Write_to_file
    
end_of_file_less_than_or_equal_start_of_slot_3:  
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char 
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
 
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char 
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
   
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_16
    bne $s7, 'O', continue_in_buffer_16

add_h_16: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_16:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j Write_to_file
    
equal_3:
    blt $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_3
    bgt $t7, $t5, end_of_file_greater_than_end_of_slot_3
    beq $t7, $t5, end_of_file_less_than_or_equal_end_of_slot_3

end_of_file_less_than_or_equal_end_of_slot_3:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j Write_to_file

end_of_file_greater_than_end_of_slot_3:
    move $v0, $t4
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t4, $v0
 
    la $s4,x 
    move $a0,$t4
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char  
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0
  
    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char   
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
   
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_17
    bne $s7, 'O', continue_in_buffer_17

add_h_17: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_17:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
  
    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j Write_to_file

greater_than_3:
    blt $t7, $t5, eee_3
    bgt $t7, $t5, qqq_3
    beq $t7, $t5, xxx_3

qqq_3:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char  
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0
  
    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char  
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_23
    bne $s7, 'O', continue_in_buffer_23

add_h_23: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_23:
    li $t8, 0
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    j Write_to_file
      
eee_3:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j Write_to_file

xxx_3:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    j Write_to_file

not_same_type_3:
    move $v0, $t6
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t6, $v0

    la $s4,x 
    move $a0,$t6
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a hypen char
    li $t8, 45
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    move $v0, $t7
    jal hoursystem # to convert hour value from 24 hour system to 12 hour system
    move $t7, $v0

    la $s4,x 
    move $a0,$t7
    li $t0, 10

    jal to_ascii

    la $t9, x
    jal copyString   # Jump to the copyString subroutine
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
#print a space char
    li $t8, 32
    sb $t8, 0($s5)
    addi $s5, $s5, 1
    
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_18
    bne $s7, 'O', continue_in_buffer_18

add_h_18: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_18:
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
    
    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    j Write_to_file
  
#######################################################################       
space:
    sb $zero, 0($s4)
  		
    la $a0,x
    jal to_integer
    move $v0, $v1

    jal convert_hour # to convert hour value from 12 hour system to 24 hour system
    move $t7, $v0
  		
    la $a0,x
    jal clear_string
    la $s4, x
   
    j loop_6
    	
hypen:
    sb $zero, 0($s4)
  		
    la $a0,x
    jal to_integer
    move $v0, $v1

    jal convert_hour # to convert hour value from 12 hour system to 24 hour system
    move $t6, $v0
  		
    la $a0,x
    jal clear_string
    la $s4, x
    
    j loop_6  
     
     
day_number_not_found:
     j loop_5

space_hypen_char:
    sb $zero, 0($s4)

    la $a0, x
    jal to_integer
    move $t2, $v1

    la $t9, x
    jal copyString   # Jump to the copyString subroutine

    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x
 
     j loop_5
     
newline_comma_char:  
    sb $zero, 0($s4)

    la $a0, x
    lb $s7, 0($a0)
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_20
    bne $s7, 'O', continue_in_buffer_20

add_h_20: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_20:  
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    sb $t0, 0($s5)
    addi $s5, $s5, 1 
    
    j loop_5

not_exist_5:
    sb $zero, 0($s4)

    la $a0, x
    lb $s7, 0($a0)
    sb $s7, 0($s5)
    addi $s5, $s5, 1
    beq $s7, 'O', add_h_19
    bne $s7, 'O', continue_in_buffer_19

add_h_19: 
    li $t9, 72 # To add H char
    sb $t9, 0($s5)
    addi $s5, $s5, 1 

continue_in_buffer_19:    
    la $a0, x
    jal clear_string		# To jump and link : Set $ra to Program Counter (return address) then jump to clear_string
    la $s4, x

    sb $t0, 0($s5)
    addi $s5, $s5, 1
    
    beqz $s1, not_exist

    jal Write_to_file

################################################ Functions used in the program ##################################################
clear_string:
#this is a function to clear a string its address stored at register $a0
clear_loop:
    lb $t8, 0($a0)
    beq $t8, $zero, done_clear
    sb $zero, 0($a0)
    addi $a0, $a0, 1
    j clear_loop
done_clear:
    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra

# This is a function to convert an ascii number to integer, its address stored in $a0 return the number in $v1  
to_integer:
    lb $t8, 0($a0)
    lb $t9, 1($a0)
    blt $t9, 48, one_digit # string is 0
    bgt $t9, 57, one_digit #string is 9

two_digit:
    addi $t8, $t8, -48
    mul $t8, $t8, 10
    addi $t9, $t9, -48
    add $v1, $t8, $t9

    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra

one_digit:
    addi $t8, $t8, -48 #convert from string to int
    move $v1, $t8

    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra

# This is a function to exit of program   
exit:
    li $v0, 10 # system call for exit
    syscall
    
# This is a function to ensure that the hour entered is within the official working hours, and to convert from the 12-hour system to the 24-hour system
convert_hour:
    beq $v0, 8, back
    beq $v0, 9, back
    beq $v0, 10, back
    beq $v0, 11, back
    beq $v0, 12, back

    beq $v0, 1, add_12
    beq $v0, 2, add_12
    beq $v0, 3, add_12
    beq $v0, 4, add_12
    beq $v0, 5, add_12

#printing the hour entered is not an official working hour
    li $v0, 4
    la $a0, notfound2
    syscall

    j done_3

# This is a function to ensure that the hour entered is within the official working hours, and to convert from the 12-hour system to the 24-hour system
convert_hour_2:
    beq $v0, 8, back
    beq $v0, 9, back
    beq $v0, 10, back
    beq $v0, 11, back
    beq $v0, 12, back

    beq $v0, 1, add_12
    beq $v0, 2, add_12
    beq $v0, 3, add_12
    beq $v0, 4, add_12
    beq $v0, 5, add_12

#printing the hour entered is not an official working hour
    li $v0, 4
    la $a0, notfound2
    syscall

    j slot_2

add_12:
    addi $v0, $v0, 12
    j back
    
hoursystem:
    beq $v0, 8, back
    beq $v0, 9, back
    beq $v0, 10, back
    beq $v0, 11, back
    beq $v0, 12, back

    beq $v0, 13, sub_12
    beq $v0, 14, sub_12
    beq $v0, 15, sub_12
    beq $v0, 16, sub_12
    beq $v0, 17, sub_12

sub_12:
    addi $v0, $v0, -12 
    j back
    	 	
enter_day_number:
#ask to enter the day number
    li $v0, 4
    la $a0, asknum
    syscall

#reading the number
    li $v0, 5
    syscall
    move $t3, $v0
    
    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra
    
enter_start_slot:
# Ask the user for the start time slot
    li $v0, 4
    la $a0, askstart
    syscall

# Read the start time slot from the user
    li $v0, 5
    syscall
    
    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra
    
enter_end_slot:
# Ask the user for the end time slot
    li $v0, 4
    la $a0, askend
    syscall

# Read the end time slot from the user
    li $v0, 5
    syscall
    
    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra

enter_type:  
# Ask the user for the type value
    li $v0, 4
    la $a0, asktype
    syscall

# Read the type from the user
    li $v0, 8           # syscall code for reading a string
    la $a0, type      # load the address of the type into $a0
    li $a1, 4         # specify the maximum length of the string
    
    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra
   
periodcondition:
    li $v0, 4
    la $a0, slotvalue
    syscall
    
    j done_3

periodcondition_2:
    li $v0, 4
    la $a0, slotvalue
    syscall
    
    j slot_2
    
typecondition:
    li $v0, 4
    la $a0, typevalue
    syscall

back:
    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra
    
# This is a function to convert an integer number to float, then find the percentage value  
div_float:  
    mtc1 $t0, $f1            # Move integer value from $t0 to $f1 (convert to floating point)
    cvt.s.w $f1, $f1          # Converting to floating point single
    
    mtc1 $t1, $f2            # Move integer value from $t1 to $f0 (convert to floating point)
    cvt.s.w $f2, $f2          # Converting to floating point single
    
# perform division
    div.s   $f12, $f1, $f2      # $f12 = $f1 / $f2
    
    li $v0, 2
    syscall

    jr $ra		# To jump register unconditionally : Jump to statement whose address is in $ra

# Write to file
Write_to_file:
# Open (for writing) a file that does not exist
  li   $v0, 13       # system call for open file
  la   $a0, filename     # file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor 
  ###############################################################
  # Write to file just opened
  li   $v0, 15       # system call for write to file
  move $a0, $s6      # file descriptor 
  la   $a1, buffer   # address of buffer from which to write
  li   $a2, 256      # hardcoded buffer length
  syscall            # write to file
  ###############################################################
  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
  ###############################################################
  
  j menu

# Subroutine to copy a string from source to destination
copyString:
    lb $t1, 0($t9)    # Load a byte from source into $t1
    sb $t1, 0($s5)    # Store the byte in $t1 to the destination
    beqz $t1, endCopy  # If the byte is null, end the copy
    addi $s5, $s5, 1   # Move to the next byte in the destination
    addi $t9, $t9, 1   # Move to the next byte in the source
    j copyString      # Jump back to copy the next byte
endCopy:
    jr $ra             # Return from the subroutine
    
to_ascii:
    div $a0, $t0
    mflo $a0
    mfhi $t1
    
    bnez $a0, to_ascii_1
    beqz  $a0, to_ascii_2
    
to_ascii_1:
    add $a0, $a0, 48
    
    sb $a0, 0($s4)
    addi $s4, $s4, 1
    
    add $t1, $t1, 48
    
    sb $t1, 0($s4)
    addi $s4, $s4, 1
    
    # Null-terminate the string
    sb $zero, 0($s4)
    
    jr $ra             # Return from the subroutine
    
to_ascii_2:
    add $t1, $t1, 48
    
    sb $t1, 0($s4)
    addi $s4, $s4, 1
    
    # Null-terminate the string
    sb $zero, 0($s4)
    
    jr $ra             # Return from the subroutine
