public with sharing class AriaStringUtils {

    /* left-pad a string with a pattern (one or more chars) till the result is the specified length */
    public static String padLeft( String stringToPad, String padPattern, Integer finalLength ) {

        Integer inputLength = stringToPad.length();
        if( inputLength >= finalLength ) { return stringToPad; }
        String newString = stringToPad; // we'll copy it, don't want to risk altering the original
        while( newString.length() < finalLength ) {
            newString = padPattern + newString; // tack the pattern onto the left
        }
        Integer startPos = newString.length() - finalLength;
        return newString.substring( startPos );
    }

    /* right-pad a string with a pattern (one or more chars) till the result is the specified length */
    public static String padRight( String stringToPad, String padPattern, Integer finalLength ) {

        Integer inputLength = stringToPad.length();
        if( inputLength >= finalLength ) { return stringToPad; }
        String newString = stringToPad; // we'll copy it, don't want to risk altering the original
        while( newString.length() < finalLength ) {
            newString = newString + padPattern; // tack the pattern onto the right
        }
        return newString.substring( 0, finalLength );
    }

    /*
     * Author: Artie Brosius
     *
     * Date: 2012Jan30
     *
     * Description: Strips all but digits from the input String
     *
     * Parameters:
     *   input: A string, possibly containing digits and other characters
     *
     * Returns:
     *   The input string, stripped of all but digits
     */
    public static String getDigitsOnly (String input) {

        String output = '';

        if (input != NULL) {
            output = input.replaceAll('\\D', '');
        }
        return output;
    }

    /*
     * Author: Artie Brosius
     *
     * Date: 2012Jan30
     *
     * Description: Returns the number of characters from the right
     *              of the string, as specified by numChars
     *
     * Parameters:
     *     input:   A string
     *  numChars:   the number of chars to return
     *
     * Returns:
     *   A string
     */
    public static String right(String s, Integer numChars) {
        String result = '';
        Integer length = s.length();

        // abcdefg

        if (numChars <= 0) { // this is an error...
            result = '';
        } else if (length > numChars) {
            result = s.substring(length - numChars);
        } else {
            result = s;
        }

        return result;
    }

    /*
     * Author: Artie Brosius
     *
     * Date: 2012Jan30
     *
     * Description: Returns the number of characters from the left
     *              of the string, as specified by numChars
     *
     * Parameters:
     *     input:   A string
     *  numChars:   the number of chars to return
     *
     * Returns:
     *   A string
     */
    public static String left(String s, Integer numChars) {
        String result = '';
        Integer length = s.length();

        if (numChars <= 0) { // this is an error...
            result = '';
        } else if (length < numChars) {
            result = s;
        } else {
            result = s.substring(0, numChars);
        }

        return result;
    }

    /*
     * Author: Artie Brosius
     *
     * Date: 2012Jan30
     *
     * Description: Returns the number of characters from the middle
     *              of the string, as specified by start and numChars.
     *              The start parameter is 1-based.
     *              If start is a negative number, it reads the string
     *              in reverse.
     *
     * Parameters:
     *     input:   A string
     *     start:   the first character to return; 1-based
     *  numChars:   the number of chars to return
     *
     * Returns:
     *   A string
     */
    public static String middle(String s, Integer start, Integer numChars) {
        String result = '';
        Integer length = s.length();
        Integer firstChar;
        Integer lastChar;

        if (start < 0) {
            firstChar = length + start; // reset to start from 1st char
        } else {
            firstChar = start - 1; // reset to 0-based
        }

        // find the position of the last character
        lastChar = firstChar + numChars;

        // if firstChar is < 0 at this point, set it to 0
        firstChar = firstChar < 0 ? 0 : firstChar;

        /*
        System.debug('start:' + start);
        System.debug('numChars: ' + numChars);
        System.debug('length: ' + length);
        System.debug('firstChar:' + firstChar);
        System.debug('lastChar:' + lastChar);
        */

        if (numChars <= 0 || lastChar < 0 || firstChar < 0) { // this is an error...
            result = '';
        } else if (firstChar < length) {

            result = s.substring(firstChar, Math.min(length, lastChar));

        } else {
            result = '';
        }

        //System.debug('result: ' + result);
        return result;
    }

    /*
     * Author: Artie Brosius
     *
     * Date: 2012Jan30
     *
     * Description: Returns the result of trimming numChars from
     *              the left of the input string
     *
     * Parameters:
     *     input:   A string
     *  numChars:   the number of chars to trim off the left side
     *
     * Returns:
     *   A string
     */
    public static String trimLeft(String s, Integer numChars) {
        String result = '';
        Integer length = s.length();

        if (numChars < 0 || numChars > length) {
            result = '';
        } else {
            result = AriaStringUtils.right(s, length - numChars);
        }

        System.debug('result: ' + result);
        return result;
    }

    /*
     * Author: Artie Brosius
     *
     * Date: 2012Jan30
     *
     * Description: Returns the result of trimming numChars from
     *              the right of the input string
     *
     * Parameters:
     *     input:   A string
     *  numChars:   the number of chars to trim off the right side
     *
     * Returns:
     *   A string
     */
    public static String trimRight(String s, Integer numChars) {
        String result = '';
        Integer length = s.length();

        if (numChars < 0 || numChars > length) {
            result = '';
        } else {
            result = AriaStringUtils.left(s, length - numChars);
        }

        System.debug('result: ' + result);
        return result;
    }

}