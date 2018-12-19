#!/bin/bash
# author: liam beckman
# created: 2018-04-03
# updated: 2018-04-23
# sources:
#   https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#   p1gradingscript, Written by Ryan Gambord (gambordr@oregonstate.edu)
#   https://stackoverflow.com/questions/8550385/how-to-read-1-line-from-2-files-sequentially
#   https://www.poetryfoundation.org/poems/142199/lines-of-force

# control-c will terminate script execution and remove temporary files
trap "echo; echo 'SIGINT received: Deleting temp files then exiting!'; clean; exit 1" INT

# Parse any args
fancy=0
POSITIONAL=()

while [ $# -gt 0 ]
do
    if [[ $1 == "--fancy" ]] || [[ $1 == "-f" ]]
    then
        # output fancy message
        fancy=1
        shift
    fi

    # save it in an array for later
    POSITIONAL+=("$1")

    # shift past argument
    shift
done

# restore positional parameters
set -- "${POSITIONAL[@]}"


# valiadate user's matrices
validate()
{
    # clear temporary validate file
    > validate$$.temp


    if [ ! -f $1 ] || [ ! -r $1 ]
    then
        echo "$1 is an unreadable file" >&2
        exit 1
    fi


    read entireline < $1
    x1=0
    for i in $entireline
    do
        x1=$((x1 + 1))
    done


    # An empty matrix.
    if [ ! -s $1 ]
    then
        echo "empty matrix error" >&2
        exit 1
    fi

    # A matrix where the final entry on a row is followed by a tab character.
    tail -n 1 $1 >> validate$$.temp


    # trailing tabs error
    trailingTab=0
    trailingTab=$(grep -c $'\t'$ validate$$.temp)
    #trailingTabOrSpace=$(grep -c '[[:blank:]]$' validate$$.temp)

    if [ $trailingTab -gt 0 ]
    then
        echo "trailing tabs error at last row in $1" >&2
        exit 1
    fi

    y=1
    while read line
    do
        # A matrix with empty lines.
        if [ -z "$line" ]
        then
            echo "empty line error at row $y in $1" >&2
            exit 1
        fi

        x=0
        for element in $line
        do

            # A matrix with any element that is not an integer.
            if [ $element -eq $element ] 2>/dev/null
            then
                ((x++))
            else
                echo "non-numeric element error in $1: $element" >&2
                exit 1
            fi

        done

        # A matrix with any element that is blank.
        if [ $x -lt $x1 ]
        then
            echo "blank element at column $x, row $y in $1" >&2
            exit 1
        fi

        ((y++))
    done < $1

    #rm -f validate$$.temp

}


dims()
{
    # clear temporary dims file
    > dims$$.temp

    rows=0
    cols=0

    # read in columns
    read entireline < $1
    for i in $entireline
    do
        cols=$((cols + 1))
    done

    # read in rows
    rows=$(wc -l < $1)

    echo -n $rows
    echo -n " "
    echo -n $cols
    echo

    echo $cols >> dims$$.temp
    echo $rows >> dims$$.temp
}

transpose()
{
    # clear temporary transpose file
    > transpose$$.temp

    # if there is a file being read in...
    if [ $1 ]
        then dims $1 &> /dev/null

    # otherwise we're reading from stdin
    else
        dims stdinLeft$$.temp &> /dev/null
    fi

    x1="$(head -n 1 dims$$.temp)"

    # convert columns to rows
    for i in $(seq 1 $x1)
    do
        cut -f$i $1 | paste -s >> transpose$$.temp
    done

    # output transpose matrix to stdin
    cat transpose$$.temp
}


mean()
{
    # clear temporary dims file
    > mean$$.temp

    dims $1 &> /dev/null

    x1="$(head -n 1 dims$$.temp)"

    # prime the transpose$$.temp file
    transpose $1 &> /dev/null

    # the x-coordinate of the current column of the ouput. Used for outputting newlines.
    endOfLine=0

    while read line
    do
        sum=0
        count=0
        average=0

        # for all elements in the matrix
        for element in $line
        do
            # add element to the total sum
            sum=$((sum + element))
            ((count++))
        done

        average=$(((sum + (count/2)*( (sum>0)*2-1 )) / count))

        # increment the x-coordinate of the mean row
        ((endOfLine++))

        # if we have not reached the end of the row...
        if [ $endOfLine -lt $x1 ]
        then
            # just print the mean and a tab
            printf "%s\t" "$average"
        else
            # otherwise print the mean
            printf "%s" "$average"
        fi

    done < transpose$$.temp
    echo

}


add()
{
    # clear temporary add files
    > addLeft$$.temp
    > addRight$$.temp


    dims $1 &> /dev/null

    x1="$(head -n 1 dims$$.temp)"
    y1="$(tail -n 1 dims$$.temp)"


    dims $2 &> /dev/null

    x2="$(head -n 1 dims$$.temp)"
    y2="$(tail -n 1 dims$$.temp)"


    if [ $x1 -ne $x2 ] || [ $y1 -ne $y2 ]
    then
        echo -e "\e[1;31mERROR\e[0m: matrix dimensions do not match" >&2 # Print error message if at top
            echo -e "matrix one: \e[1;31m$y1 x $x1\e[0m" >&2
            echo -e "matrix two: \e[1;31m$y2 x $x2\e[0m" >&2
        exit 1
    fi



    # convert first matrix into a "X by 1" matrix in temp file
    # this will make it easier to draw elements from
    cat $1 | tr '\t' '\n' >> addLeft$$.temp

    # convert second matrix into a "X by 1" matrix in temp file
    # this will make it easier to draw elements from
    cat $2 | tr '\t' '\n' >> addRight$$.temp

    # the given column number of the sum matrix. Used for outputting newlines.
    endOfLine=0

    # read in both matrices and add elements
    while read left && read right <&3
    do

        # calculate sum
        sum=$((left + right))

        # increment the x-coordinate of the sum matrix
        ((endOfLine++))

        # if we have not reached the end of the row...
        if [ $endOfLine -lt $x1 ]
        then
            # just print the mean and a tab
            printf "%s\t" $sum
        else
            # otherwise print the mean
            printf "%s" $sum
            echo

            # reset column position of product matrix
            endOfLine=0
        fi
    done < addLeft$$.temp 3< addRight$$.temp
}


multiply()
{
    # clear temporary multiply files
    > multiplyLeft$$.temp
    > multiplyRight$$.temp


    # transpose second matrix to make it easier to read in elements
    transpose $2 &> /dev/null

    # get first matrix's dimensions
    dims $1 &> /dev/null

    x1="$(head -n 1 dims$$.temp)"
    y1="$(tail -n 1 dims$$.temp)"

    # get second matrix's dimensions
    dims $2 &> /dev/null

    x2="$(head -n 1 dims$$.temp)"
    y2="$(tail -n 1 dims$$.temp)"


    # error message for misproportioned matrices
    if [ $x1 -ne $y2 ]
    then
        echo -e "\e[1;31mERROR\e[0m: matrix dimensions do not match" >&2
            echo -e "matrix one: $y1 x \e[1;31m$x1\e[0m" >&2
            echo -e "matrix two: \e[1;31m$y2\e[0m x $x2" >&2
        exit 1
    fi


    # add first matrix into array
    arr2=0
    while read line
    do
        for element in $line
        do
            arr2+=($element)
        done
    done < $1

    # add second matrix into array
    arr3=0
    while read line
    do
        for element in $line
        do
            #echo "element: $element"
            arr3+=($element)
            #echo arr2
        done
    done < $2


    # the number of processed rows in the first matrix
    rowTotal=0

    # the x-coordinate of the current column of the first matrix. Used for outputting newlines.
    endOfLine=0

    while read line
    do
        # the column that is currently being processed
        columnIndex=0
        while [ $columnIndex -lt $x2 ]
        do
            # the number of processed columns in the second matrix
            columnTotal=0

            # the row that is currently being processed
            rowIndex=0

            # sum of multiplications between elements.
            sum=0

            while [ $columnTotal -lt $x1 ]
            do
                # left element in multiplication
                left=${arr2[$x1 * $rowTotal + $rowIndex + 1 ]}

                # right element in multiplication
                right=${arr3[$x2 * $columnTotal + $columnIndex + 1]}

                #add to sum the product of the left and right elements
                sum=$((sum + left * right))

                #increment the total number of columns that have been processed
                ((columnTotal++))

                #increment the row index of the first matrix
                ((rowIndex++))
            done

            #increment the column index of the second matrix
            ((columnIndex++))

            # increment the x-coordinate of the product matrix
            ((endOfLine++))

            # if we have not reached the end of the row...
            if [ $endOfLine -lt $x2 ]
            then
                # just print the sum and a tab
                printf "%s\t" $sum
            else
                # otherwise print the sum
                printf "%s" $sum

                # enter new row in product matrix
                echo

                # reset column position of product matrix
                endOfLine=0
            fi
        done

            #increment the total number of rows that have been processed
            ((rowTotal++))

    done < $1

runtime=$((end-start))
echo $runtime > timeMultiply.temp

}


clean()
{
    # remove temporary files
    rm -f addLeft$$.temp
    rm -f addRight$$.temp

    rm -f dims*.temp

    rm -f mean$$.temp

    rm -f multiplyLeft*.temp
    rm -f multiplyRight*.temp

    rm -f stdinLeft$$.temp
    rm -f stdinRight$$.temp

    rm -f transpose*.temp

    rm -f validate*.temp

}

fancyGoodbye()
{
    echo
    echo "    [1m     [32mDon't worry,     [34m__
           [32m\"Bee\" happy!  [34m// \\
                         \\\_/ [33m//
       [35m''-.._.-''-.._.. [33m-(||)(')
                         '''[0m"
}

main()
{
    # inavlid number of operations provided
    [ $# -gt 4 ] && echo "too many arguments specified" >&2 && exit 1


    # validate input
    if [ $# -eq 2 ]
    then
        validate $2

    elif [ $# -eq 3 ]
    then
        validate $2
        validate $3
    fi

    # functions that accept input from stdin
    if [ $1 = "dims" ] || [ $1 = "transpose" ] || [ $1 = "mean" ]
    then
        # read from standard input
        if [ $# -eq 1 ]
        then
            cat > stdinLeft$$.temp
            cat > stdinRight$$.temp

        # validate input
            if [ -s stdinLeft$$.temp ]
            then
                validate stdinLeft$$.temp
            fi

            if [ -s stdinRight$$.temp ]
            then
                validate stdinRight$$.temp
            fi
        fi

    else
        # inavlid number of operations provided
        [ $# -lt 2 ] && echo "too few arguments specified" >&2 && exit 1
    fi


    case $1 in
        # call dims function
        dims)
            if [ $2 ];
            then
                dims $2
            else
                dims stdinLeft$$.temp
            fi
            ;;
        # call transpose function
        transpose)
            if [ $2 ];
            then
                transpose $2
            else
                transpose stdinLeft$$.temp
            fi
            ;;
        # call mean function
        mean)
            if [ $2 ];
            then
                mean $2
            else
                mean stdinLeft$$.temp
            fi
            ;;
        # call add function
        add)
            add $2 $3
            ;;
        # call multiply function
        multiply)
            multiply $2 $3
            ;;
        # invalid operation provided
        *)
            echo "unknown operation provided" >&2
            ;;
    esac


    # call fancy goodbye function
    if [ $fancy -eq 1 ]
    then
        fancyGoodbye
    fi

    # call clean function and remove temporary files
    clean
}

# call main function with all arguments
main $@


# ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~
# P O E T R Y  of the  M O N T H
# ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~
#
# Lines of Force
# By Thomas Centolella
#
# ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~
#
# The pleasure of walking a long time on the mountain
# without seeing a human being, much less speaking to one.
#
# And the pleasure of speaking when one is suddenly there.
# The upgrade from wary to tolerant to convivial,
# so unlike two brisk bodies on a busy street
# for whom a sudden magnetic attraction
# is a mistake, awkwardness, something to be sorry for.
#
# But to loiter, however briefly, in a clearing
# where two paths intersect in the matrix of chance.
# To stop here speaking the few words that come to mind.
# A greeting. Some earnest talk of weather.
# A little history of the day.
#
# To stand there then and say nothing.
# To slowly look around past each other.
# Notice the green tang pines exude in the heat
# and the denser sweat of human effort.
#
# To have nothing left to say
# but not wanting just yet to move on.
# The tension between you, a gossamer thread.
# It trembles in the breeze, holding
# the thin light it transmits.
#
# To be held in that
# line of force, however briefly,
# as if it were all that mattered.
#
# And then to move on.
# With equal energy, with equal pleasure.
#
# ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~ * ~
