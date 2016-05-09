#!/bin/bash
# See Descript.text in boot folder for more information (multiply addresses by 2 for hex format).
# This script uses S-Record intensively (see www.s-record.com for more information).
# Only for D2036 for now.

boot_hex=""
app_hex=""
merge_hex=""

readonly BOOT_START_ADDR=0x800
readonly APP_START_ADDR=0x1800
readonly ISR_START_ADDR=0x8
(( GOTO_START_ADDR=$BOOT_START_ADDR - 8 ))
readonly GOTO_START_ADDR

# Test if srec_cat is present.
if ! hash srec_cat &> /dev/null; then
    echo "I require srec_cat but it's not installed."
    echo "Aborting."
    exit 1
fi

print_usage() {
    echo "Tool to merge a bootloader and an application:"
    echo " -h   - display this help message"
    echo " -a   - name of the application file (Intel hex)"
    echo " -b   - name of the bootloader file (Intel hex)"
    echo " -o   - name of the output file (default: standard output)"
    echo " -v   - verbose mode"
}

while getopts ":b:a:o:hv" opt; do
    case $opt in
        b)
            boot_hex="$OPTARG"
            ;;
        a)
            app_hex="$OPTARG"
            ;;
        o)
            merge_hex="$OPTARG"
            ;;
        h)
            print_usage
            exit 0
            ;;
        v)
            verbose=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            print_usage
            exit 1
            ;;
        \:) echo "Option -$OPTARG required an argument" >&2
            print_usage
            exit 1
            ;;
    esac
done

# Verbose on or off.
chatter() {
    if [[ $verbose ]]; then
        chatter() {
            echo "$@"
            $@
        }
    else
        chatter() {
            $@
        }
    fi

    chatter "$@"
}

if [[ -z $boot_hex ]] || [[ -z $app_hex ]]; then
    echo "Bootloader and application files are both needed" >&2
    exit 1
fi

if [[ ! -f "$boot_hex" ]]; then
    echo "Problem with the bootloader file" >&2
    exit 1
fi

if [[ ! -f "$app_hex" ]]; then
    echo "Problem with the application file" >&2
    exit 1
fi

#
# Here is the interesting part !
# For help, see srec_input, srec_examples and srec_cat manuals.
#

# Remove ISR lines...
clean_boot="$boot_hex -Intel -exclude $ISR_START_ADDR $BOOT_START_ADDR"
# and application lines of bootloader HEX.
clean_boot+=" $APP_START_ADDR -maximum-addr $boot_hex -Intel"

# Take goto lines and move them before bootloader lines
goto_part="$app_hex -Intel -crop 0 $ISR_START_ADDR -offset=$GOTO_START_ADDR"
# Take ISR lines...
appli_part="$app_hex -Intel -crop $ISR_START_ADDR $GOTO_START_ADDR"
# and application lines of application HEX.
appli_part+=" $APP_START_ADDR -maximum-addr $app_hex -Intel"

chatter srec_cat $clean_boot $goto_part $appli_part -o \
    $merge_hex -Intel -obs=16

# Make sure it is in DOS format for the production team.
chatter u2d $merge_hex

