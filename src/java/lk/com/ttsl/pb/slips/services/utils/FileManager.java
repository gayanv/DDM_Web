/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package lk.com.ttsl.pb.slips.services.utils;

import java.io.*;

/**
 *
 * @author Dinesh
 */
public class FileManager
{

    public FileManager()
    {
    }

    public synchronized boolean createFile(File file, String fileData, boolean deleteIfExists)
    {
        boolean status = false;
        FileInputStream fis = null;
        BufferedInputStream bis = null;
        FileOutputStream fos = null;
        BufferedOutputStream bos = null;
        Writer writer = null;

        if (file.exists())
        {
            if (deleteIfExists)
            {
                if (file.canWrite())
                {
                    if (!file.delete())
                    {
                        System.out.println("WARNING : Unable to delete the existing destination file.");
                        return false;
                    }
                    else
                    {
                        try
                        {
                            writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "utf-8"));
                            writer.write(fileData);
                            status = true;
                        }
                        catch (IOException e)
                        {
                            status = false;
                            e.printStackTrace();
                        }
                        finally
                        {
                            try
                            {
                                writer.close();
                            }
                            catch (Exception e)
                            {
                                status = false;
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }
            else
            {
                status = true;
            }
        }
        else
        {
            try
            {
                writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "utf-8"));
                writer.write(fileData);
                status = true;
            }
            catch (IOException e)
            {
                status = false;
                e.printStackTrace();
            }
            finally
            {
                try
                {
                    writer.close();
                }
                catch (Exception e)
                {
                    status = false;
                    e.printStackTrace();
                }
            }
        }

        return status;
    }

    /**
     * @param file - the file object which needs to be deleted.
     * @return boolean - the status of the file deletion.
     */
    public synchronized boolean clean(File file)
    {
        boolean status = false;

        if (file.exists())
        {
            if (file.canWrite())
            {
                if (file.delete())
                {
                    status = true;
                }
                else
                {
                    file.deleteOnExit();
                    System.out.println("WARNING : " + file.toString() + " file deletion failed * 1.");

                }
            }
            else
            {
                if (file.setWritable(true, false))
                {
                    if (file.delete())
                    {
                        status = true;
                    }
                    else
                    {
                        file.deleteOnExit();
                        System.out.println("WARNING : " + file.toString() + " file deletion failed * 2.");

                    }
                }
                else
                {
                    file.deleteOnExit();
                    System.out.println("WARNING : " + file.toString() + " couldn't delete the file (permission issue - *set file delete on exit).");

                }
            }
        }
        else
        {
            status = true;
        }

        return status;
    }

    public synchronized boolean move(File file, String newDirPath)
    {
        boolean status = false;

        if (file.exists())
        {
            File fDir = new File(newDirPath);

            if (fDir.exists())
            {
                File outFile = new File(newDirPath + file.getName());

                if (outFile.exists())
                {
                    this.clean(outFile);
                }

                if (file.renameTo(new File(newDirPath + file.getName())))
                {
                    status = true;
                }
                else
                {
                    System.out.println("WARNING : " + file.toString() + " file moving failed * 1.");

                }
            }
            else
            {
                if (fDir.mkdirs())
                {
                    File outFile = new File(newDirPath + file.getName());

                    if (outFile.exists())
                    {
                        this.clean(outFile);
                    }

                    if (file.renameTo(new File(newDirPath + file.getName())))
                    {
                        status = true;
                    }
                    else
                    {
                        System.out.println("WARNING : " + file.toString() + " file moving failed * 2.");

                    }
                }
                else
                {
                    System.out.println("WARNING : " + file.toString() + " directory creation failed.");

                }
            }
        }

        return status;
    }

    public synchronized boolean copyfile(File sourceFile, File destinationFile, boolean deleteIfExists)
    {
        boolean status = false;
        FileInputStream fis = null;
        BufferedInputStream bis = null;
        FileOutputStream fos = null;
        BufferedOutputStream bos = null;

        if (!sourceFile.exists())
        {
            System.out.println("WARNING : Source file doesn't exists.");
            return false;
        }
        else
        {
            if (!sourceFile.canRead())
            {
                System.out.println("WARNING :Couldn't read the source file.");
                return false;
            }
        }

        if (destinationFile.exists())
        {
            if (deleteIfExists)
            {
                if (destinationFile.canWrite())
                {
                    if (!destinationFile.delete())
                    {
                        System.out.println("WARNING : Unable to delete the existing destination file.");
                        return false;
                    }
                    else
                    {
                        try
                        {
                            fis = new FileInputStream(sourceFile);
                            bis = new BufferedInputStream(fis);

                            fos = new FileOutputStream(destinationFile);
                            bos = new BufferedOutputStream(fos);

                            byte[] dataBuf = new byte[4096];

                            int count;

                            while ((count = bis.read(dataBuf)) != -1)
                            {
                                bos.write(dataBuf, 0, count);
                            }

                            if (bos != null)
                            {
                                bos.flush();
                                bos.close();
                            }
                            if (fos != null)
                            {
                                fos.flush();
                                fos.close();
                            }
                            if (bis != null)
                            {
                                bis.close();
                            }
                            if (fis != null)
                            {
                                fis.close();
                            }

                            status = true;

                        }
                        catch (IOException ex)
                        {
                            status = false;
                            ex.printStackTrace();
                        }
                        finally
                        {
                            try
                            {
                                if (bos != null)
                                {
                                    bos.flush();
                                    bos.close();
                                }
                                if (fos != null)
                                {
                                    fos.flush();
                                    fos.close();
                                }
                                if (bis != null)
                                {
                                    bis.close();
                                }
                                if (fis != null)
                                {
                                    fis.close();
                                }
                            }
                            catch (Exception e)
                            {
                                status = false;
                                e.printStackTrace();
                            }
                        }

                    }
                }
            }
            else
            {
                status = true;
            }
        }
        else
        {
            try
            {
                fis = new FileInputStream(sourceFile);
                bis = new BufferedInputStream(fis);

                fos = new FileOutputStream(destinationFile);
                bos = new BufferedOutputStream(fos);

                byte[] dataBuf = new byte[4096];

                int count;

                while ((count = bis.read(dataBuf)) != -1)
                {
                    bos.write(dataBuf, 0, count);
                }

                if (bos != null)
                {
                    bos.flush();
                    bos.close();
                }
                if (fos != null)
                {
                    fos.flush();
                    fos.close();
                }
                if (bis != null)
                {
                    bis.close();
                }
                if (fis != null)
                {
                    fis.close();
                }

                status = true;

            }
            catch (IOException ex)
            {
                status = false;
                ex.printStackTrace();
            }
            finally
            {
                try
                {
                    if (bos != null)
                    {
                        bos.flush();
                        bos.close();
                    }
                    if (fos != null)
                    {
                        fos.flush();
                        fos.close();
                    }
                    if (bis != null)
                    {
                        bis.close();
                    }
                    if (fis != null)
                    {
                        fis.close();
                    }
                }
                catch (Exception e)
                {
                    status = false;
                    e.printStackTrace();
                }
            }
        }
        return status;
    }
}
