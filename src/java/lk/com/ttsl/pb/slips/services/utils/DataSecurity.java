/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;
import lk.com.ttsl.pb.slips.common.utils.DDM_Constants;

/**
 *
 * @author Dinesh
 */
public class DataSecurity
{

    /**
     *
     * @param file file object which holds the key
     * @return SecretKey
     */
    public SecretKey getKey(File file)
    {
        FileInputStream fin = null;
        DataInputStream din = null;
        SecretKey key = null;

        try
        {
            fin = new FileInputStream(file);
            din = new DataInputStream(fin);
            byte[] byteArray = new byte[(int) file.length()];
            din.readFully(byteArray);
            //din.close();

            DESedeKeySpec keyspec = new DESedeKeySpec(byteArray);

            SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("AES/ECB/PKCS5Padding");
            key = keyfactory.generateSecret(keyspec);
        }
        catch (Exception e)
        {
            System.out.println("getKey(File file) Error - " + e.getMessage());
        }
        finally
        {

            try
            {
                if (din != null)
                {
                    din.close();
                }
                if (fin != null)
                {
                    fin.close();
                }
            }
            catch (Exception e)
            {
                System.out.println(e.getMessage());
            }

        }

        return key;
    }

    /**
     *
     * @param byteArray - byte array which holds the key
     * @return SecretKey
     */
    public SecretKey getKeyAES(byte[] byteArray)
    {
        SecretKey key;

        //System.out.println("byte[] byteArray - " + byteArray.length);
        
        key = new SecretKeySpec(byteArray, "AES");
        
        System.out.println("AES key--->" + key);

        return key;
    }
    
    public SecretKey getKeyDES_Ede(byte[] byteArray) throws IOException, InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException
    {
        SecretKey key = null;

        DESedeKeySpec keyspec = new DESedeKeySpec(byteArray);
        SecretKeyFactory keyfactory = SecretKeyFactory.getInstance("DESede");
        key = keyfactory.generateSecret(keyspec);
        
        System.out.println("DESede key--->" + key);

        return key;
    }

    public static String getSecureKey(String password, byte[] salt) throws Exception
    {

        String sk = null;

        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        byte[] bytes = md.digest(password.getBytes());
        System.out.println("byte[] bytes - " + bytes.length);

        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < bytes.length; i++)
        {
            sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
        }

        sk = sb.toString();

        return sk;
    }

    public static String getSecureKeyAES(String password, byte[] salt) throws Exception
    {

        String sk = null;

        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        byte[] bytes = md.digest(password.getBytes());
        System.out.println("byte[] bytes - " + bytes.length);

        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < bytes.length; i++)
        {
            sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
        }

        sk = sb.toString().substring(0, 32);

        return sk;
    }

    public static byte[] getSalt() throws NoSuchAlgorithmException
    {
        SecureRandom random = new SecureRandom(DDM_Constants.sec_key.getBytes());
        byte[] salt = new byte[16];
        random.nextBytes(salt);

        System.out.println("salt - " + salt.toString());

        return salt;
    }

    public String encrypt(SecretKey key, String data)
    {
        String encData = null;
        byte[] dataBytes = null;
        byte[] encDataBytes = null;

        try
        {
            // Create and initialize the decryption engine
            //Cipher eCipher = Cipher.getInstance("DESede");

            Cipher eCipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            eCipher.init(Cipher.ENCRYPT_MODE, key);

            byte[] bytes = data.getBytes("UTF-8");
            byte[] bytesEncrypted = eCipher.doFinal(bytes);
            encData = Base64.encodeBase64String(bytesEncrypted);

        }
        catch (Exception e)
        {
            System.out.println("Encrypt Error - " + e.getMessage());
        }

        return encData;
    }

    public void encryptAES(SecretKey key, File in, File out)
            throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IOException, IllegalBlockSizeException, BadPaddingException
    {
        FileInputStream fin = null;
        FileOutputStream fout = null;
        BufferedInputStream bin = null;
        BufferedOutputStream bout = null;
        try
        {
            fin = new FileInputStream(in);
            fout = new FileOutputStream(out);
            bin = new BufferedInputStream(fin);
            bout = new BufferedOutputStream(fout);

            //Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(1, key);

            byte[] buffer = new byte['?'];
            int bytesRead;

            while ((bytesRead = bin.read(buffer)) != -1)
            {
                bout.write(cipher.update(buffer, 0, bytesRead));
            }

            bout.write(cipher.doFinal());
        }
        finally
        {
            try
            {
                if (bout != null)
                {
                    bout.flush();
                    bout.close();
                }
                if (fout != null)
                {
                    fout.flush();
                    fout.close();
                }
                if (bin != null)
                {
                    bin.close();
                }
                if (fin != null)
                {
                    fin.close();
                }
            }
            catch (IOException e)
            {
                System.out.println("Error - " + e.getMessage());
            }
        }
    }
    
    public void encryptDes_Ede(SecretKey key, File in, File out)
            throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IOException, IllegalBlockSizeException, BadPaddingException
    {
        FileInputStream fin = null;
        FileOutputStream fout = null;
        BufferedInputStream bin = null;
        BufferedOutputStream bout = null;
        try
        {
            fin = new FileInputStream(in);
            fout = new FileOutputStream(out);
            bin = new BufferedInputStream(fin);
            bout = new BufferedOutputStream(fout);

            //Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            Cipher cipher = Cipher.getInstance("DESede");
            cipher.init(1, key);

            byte[] buffer = new byte['?'];
            int bytesRead;

            while ((bytesRead = bin.read(buffer)) != -1)
            {
                bout.write(cipher.update(buffer, 0, bytesRead));
            }

            bout.write(cipher.doFinal());
        }
        finally
        {
            try
            {
                if (bout != null)
                {
                    bout.flush();
                    bout.close();
                }
                if (fout != null)
                {
                    fout.flush();
                    fout.close();
                }
                if (bin != null)
                {
                    bin.close();
                }
                if (fin != null)
                {
                    fin.close();
                }
            }
            catch (IOException e)
            {
                System.out.println("Error - " + e.getMessage());
            }
        }
    }

    public String decrypt(SecretKey key, String data)
    {
        String decData = null;
        byte[] dataBytes = null;
        byte[] decDataBytes = null;

        try
        {
            Cipher dCipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            dCipher.init(Cipher.DECRYPT_MODE, key);
            // Read bytes, decrypt, and write them out.
            byte[] bytes = data.getBytes();
            byte[] bytesDecrypted = dCipher.doFinal(Base64.decodeBase64(bytes));
            decData = new String(bytesDecrypted);
        }
        catch (Exception e)
        {
            System.out.println("Decrypt Error - " + e.getMessage());
        }

        return decData;
    }

    public void decryptAES(SecretKey key, File in, File out) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IOException, IllegalBlockSizeException, BadPaddingException
    {
        FileInputStream fin = null;
        FileOutputStream fout = null;
        BufferedInputStream bin = null;
        BufferedOutputStream bout = null;

        try
        {
            fin = new FileInputStream(in);
            fout = new FileOutputStream(out);
            bin = new BufferedInputStream(fin);
            bout = new BufferedOutputStream(fout);

            // Create and initialize the decryption engine
            //Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, key);
            // Read bytes, decrypt, and write them out.

            int BUFFER = (int) in.length();

            byte[] buffer = new byte[BUFFER];

            int bytesRead;

            while ((bytesRead = bin.read(buffer)) != -1)
            {
                bout.write(cipher.update(buffer, 0, bytesRead));
            }

            bout.write(cipher.doFinal());
        }
        finally
        {
            try
            {
                if (bout != null)
                {
                    bout.flush();
                    bout.close();
                }
                if (fout != null)
                {
                    fout.flush();
                    fout.close();
                }
                if (bin != null)
                {
                    bin.close();
                }
                if (fin != null)
                {
                    fin.close();
                }

            }
            catch (IOException e)
            {
                System.out.println("Error occured while decrypt file -  (" + in.toString() + ") " + e.getMessage());
            }
        }
    }
    
    public void decryptDes_Ede(SecretKey key, File in, File out) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IOException, IllegalBlockSizeException, BadPaddingException
    {
        FileInputStream fin = null;
        FileOutputStream fout = null;
        BufferedInputStream bin = null;
        BufferedOutputStream bout = null;

        try
        {
            fin = new FileInputStream(in);
            fout = new FileOutputStream(out);
            bin = new BufferedInputStream(fin);
            bout = new BufferedOutputStream(fout);

            // Create and initialize the decryption engine
            //Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            Cipher cipher = Cipher.getInstance("DESede");
            cipher.init(Cipher.DECRYPT_MODE, key);
            // Read bytes, decrypt, and write them out.

            int BUFFER = (int) in.length();

            byte[] buffer = new byte[BUFFER];

            int bytesRead;

            while ((bytesRead = bin.read(buffer)) != -1)
            {
                bout.write(cipher.update(buffer, 0, bytesRead));
            }

            bout.write(cipher.doFinal());
        }
        finally
        {
            try
            {
                if (bout != null)
                {
                    bout.flush();
                    bout.close();
                }
                if (fout != null)
                {
                    fout.flush();
                    fout.close();
                }
                if (bin != null)
                {
                    bin.close();
                }
                if (fin != null)
                {
                    fin.close();
                }

            }
            catch (IOException e)
            {
                System.out.println("Error occured while decrypt file -  (" + in.toString() + ") " + e.getMessage());
            }
        }
    }

}
