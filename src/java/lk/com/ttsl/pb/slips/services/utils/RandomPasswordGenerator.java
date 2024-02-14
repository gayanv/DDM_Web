/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author Dinesh
 */
public class RandomPasswordGenerator
{

    private static final String CHAR_LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPERCASE = CHAR_LOWERCASE.toUpperCase();
    private static final String DIGIT = "0123456789";
    private static final String CHAR_SPECIAL = "~!@#$%^&.:;',?=<>*/+–([{}])";
    private static final int MIN_PWD_LENGTH = 8;
    private static final int AVG_PWD_LENGTH = 15;
    private static final int STRONG_PWD_LENGTH = 20;

    private static final String PASSWORD_ALLOW = CHAR_LOWERCASE + CHAR_UPPERCASE + DIGIT + CHAR_SPECIAL;
    
    private static final String PASSWORD_ALLOW_SIMPLE = CHAR_LOWERCASE + CHAR_UPPERCASE + DIGIT ;

    private static final SecureRandom random = new SecureRandom();

    public static String generateStrongPassword()
    {

        StringBuilder result = new StringBuilder(STRONG_PWD_LENGTH);

        // at least 2 chars (lowercase)
        String strLowerCase = generateRandomString(CHAR_LOWERCASE, 2);
        //System.out.format("%-20s: %s%n", "Chars (Lowercase)", strLowerCase);
        result.append(strLowerCase);

        // at least 2 chars (uppercase)
        String strUppercaseCase = generateRandomString(CHAR_UPPERCASE, 2);
        //System.out.format("%-20s: %s%n", "Chars (Uppercase)", strUppercaseCase);
        result.append(strUppercaseCase);

        // at least 2 digits
        String strDigit = generateRandomString(DIGIT, 2);
        //System.out.format("%-20s: %s%n", "Digits", strDigit);
        result.append(strDigit);

        // at least 2 special characters (punctuation + symbols)
        String strSpecialChar = generateRandomString(CHAR_SPECIAL, 2);
        //System.out.format("%-20s: %s%n", "Special chars", strSpecialChar);
        result.append(strSpecialChar);

        // remaining, just random
        String strOther = generateRandomString(PASSWORD_ALLOW, STRONG_PWD_LENGTH - 8);
        //System.out.format("%-20s: %s%n", "Others", strOther);
        result.append(strOther);

        String password = result.toString();
        // combine all
        System.out.format("%-20s: %s%n", "Password", password);
        // shuffle again
        System.out.format("%-20s: %s%n", "Final Password", shuffleString(password));
        //System.out.format("%-20s: %s%n%n", "Password Length", password.length());

        return shuffleString(password);
    }
    
        public static String generateModeratePassword()
    {

        StringBuilder result = new StringBuilder(AVG_PWD_LENGTH);

        // at least 2 chars (lowercase)
        String strLowerCase = generateRandomString(CHAR_LOWERCASE, 2);
        //System.out.format("%-20s: %s%n", "Chars (Lowercase)", strLowerCase);
        result.append(strLowerCase);

        // at least 2 chars (uppercase)
        String strUppercaseCase = generateRandomString(CHAR_UPPERCASE, 2);
        //System.out.format("%-20s: %s%n", "Chars (Uppercase)", strUppercaseCase);
        result.append(strUppercaseCase);

        // at least 2 digits
        String strDigit = generateRandomString(DIGIT, 2);
        //System.out.format("%-20s: %s%n", "Digits", strDigit);
        result.append(strDigit);

        // at least 2 special characters (punctuation + symbols)
        String strSpecialChar = generateRandomString(CHAR_SPECIAL, 2);
        //System.out.format("%-20s: %s%n", "Special chars", strSpecialChar);
        result.append(strSpecialChar);

        // remaining, just random
        String strOther = generateRandomString(PASSWORD_ALLOW, AVG_PWD_LENGTH - 8);
        //System.out.format("%-20s: %s%n", "Others", strOther);
        result.append(strOther);

        String password = result.toString();
        // combine all
        System.out.format("%-20s: %s%n", "Password", password);
        // shuffle again
        System.out.format("%-20s: %s%n", "Final Password", shuffleString(password));
        //System.out.format("%-20s: %s%n%n", "Password Length", password.length());

        return shuffleString(password);
    }

    public static String generatePassword(int pwdLength)
    {
        if (pwdLength < 8)
        {
            pwdLength = 8;
        }

        StringBuilder result = new StringBuilder(pwdLength);

        // at least 2 chars (lowercase)
        String strLowerCase = generateRandomString(CHAR_LOWERCASE, 2);
        result.append(strLowerCase);

        // at least 2 chars (uppercase)
        String strUppercaseCase = generateRandomString(CHAR_UPPERCASE, 2);
        result.append(strUppercaseCase);

        // at least 2 digits
        String strDigit = generateRandomString(DIGIT, 2);
        result.append(strDigit);

        // at least 1 special characters (punctuation)
        String strSpecialChar = generateRandomString(CHAR_SPECIAL, 1);
        result.append(strSpecialChar);

        // remaining, just random
        String strOther = generateRandomString(PASSWORD_ALLOW_SIMPLE, pwdLength - 7);
        result.append(strOther);

        String password = result.toString();

        return shuffleString(password);
    }

    // generate a random char[], based on `input`
    private static String generateRandomString(String input, int size)
    {

        if (input == null || input.length() <= 0)
        {
            throw new IllegalArgumentException("Invalid input.");
        }
        if (size < 1)
        {
            throw new IllegalArgumentException("Invalid size.");
        }

        StringBuilder result = new StringBuilder(size);
        for (int i = 0; i < size; i++)
        {
            // produce a random order
            int index = random.nextInt(input.length());
            result.append(input.charAt(index));
        }
        return result.toString();
    }

    // for final password, make it more random
    public static String shuffleString(String input)
    {
        List<String> result = Arrays.asList(input.split(""));
        Collections.shuffle(result);
        // java 8
        return result.stream().collect(Collectors.joining());
    }

//    public static void main(String[] args)
//    {
//        generateStrongPassword();
//        generateModeratePassword();
//        generatePassword(8);
//    }

}
