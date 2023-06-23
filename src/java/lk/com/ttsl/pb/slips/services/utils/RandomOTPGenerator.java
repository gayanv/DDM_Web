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
public class RandomOTPGenerator
{

    private static final String CHAR_LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPERCASE = CHAR_LOWERCASE.toUpperCase();
    private static final String DIGIT = "0123456789"; 
    private static final int MIN_OTP_LENGTH = 7;
    private static final int AVG_OTP_LENGTH = 9;
    private static final int STRONG_OTP_LENGTH = 12;

    private static final SecureRandom random = new SecureRandom();

    public static String generateStrongOTP()
    {
        StringBuilder result = new StringBuilder(STRONG_OTP_LENGTH);

        // 3 chars (uppercase)
        String strUppercaseCase = generateRandomString(CHAR_UPPERCASE, 3);        
        String shuffledUpperCaseLetters = shuffleString(strUppercaseCase);

        //  9 digits
        String strDigit = generateRandomString(DIGIT, 9);
        String shuffledDigits = shuffleString(strDigit);
        
        result.append(shuffledUpperCaseLetters);
        result.append(shuffledDigits);
        
        String otp = result.toString();
        
        return otp;
    }
    
        public static String generateAvgOTP()
    {

        StringBuilder result = new StringBuilder(AVG_OTP_LENGTH);

        // 3 chars (uppercase)
        String strUppercaseCase = generateRandomString(CHAR_UPPERCASE, 3);        
        String shuffledUpperCaseLetters = shuffleString(strUppercaseCase);

        //  6 digits
        String strDigit = generateRandomString(DIGIT, 6);
        String shuffledDigits = shuffleString(strDigit);
        
        result.append(shuffledUpperCaseLetters);        
        result.append(shuffledDigits);
        
        String otp = result.toString();
        
        return otp;
    }

    public static String generateMinOTP()
    {
        StringBuilder result = new StringBuilder(MIN_OTP_LENGTH);

        // 3 chars (uppercase)
        String strUppercaseCase = generateRandomString(CHAR_UPPERCASE, 3);        
        String shuffledUpperCaseLetters = shuffleString(strUppercaseCase);

        //  4 digits
        String strDigit = generateRandomString(DIGIT, 4);
        String shuffledDigits = shuffleString(strDigit);
        
        result.append(shuffledUpperCaseLetters);
        result.append(shuffledDigits);
        
        String otp = result.toString();
        
        return otp;
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

    public static void main(String[] args)
    {
        String s_OPT = generateStrongOTP();
        System.out.println("s_OPT ----> " + s_OPT);
        
        String a_OPT = generateAvgOTP();
        System.out.println("a_OPT ----> " + a_OPT);
        
        String m_OPT = generateMinOTP();
        System.out.println("m_OPT ----> " + m_OPT);
    }

}
