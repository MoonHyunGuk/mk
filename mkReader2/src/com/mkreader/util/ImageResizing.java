package com.mkreader.util;

import java.awt.Image;
import java.awt.color.ColorSpace;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.swing.ImageIcon;
import javax.imageio.ImageIO;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.sun.image.codec.jpeg.ImageFormatException;

public class ImageResizing {
	
	/**
	 * 실제 리사이징 로직 private
	 * @param imgSource
	 * @param target
	 * @param targetW
	 * @param targetH
	 * @throws Exception
	 */
	private static void createThumbnail(Image imgSource, String target, int targetW, int targetH) throws Exception, ImageFormatException {
		
		Image imgTarget = imgSource.getScaledInstance(targetW, targetH, Image.SCALE_SMOOTH);
		int pixels[] = new int[targetW * targetH];
		PixelGrabber pg = new PixelGrabber(imgTarget, 0, 0, targetW, targetH, pixels, 0, targetW);
		pg.grabPixels();
		BufferedImage bi = new BufferedImage(targetW, targetH, BufferedImage.TYPE_INT_RGB);
		
		bi.setRGB(0, 0, targetW, targetH, pixels, 0, targetW);
		FileOutputStream fos = new FileOutputStream(target);
		JPEGImageEncoder jpeg = JPEGCodec.createJPEGEncoder(fos);
		JPEGEncodeParam jep = jpeg.getDefaultJPEGEncodeParam(bi);
		jep.setQuality(1, false);
		jpeg.encode(bi, jep);
		fos.close();
	}
	
	private static boolean checkException(String filename) 
    { 
        boolean result = true; 
        BufferedImage img = null; 
        try 
        { 
            img = ImageIO.read(new File(filename)); 
        } 
        catch (IOException e) 
        { 
            System.out.println(e.getMessage() + ": " + filename);
            result = false;
        } 
        return result; 
    } 

	
	/**
	 * 결과물의 폭과 높이 를 모두 알때
	 * @param soruce
	 * @param target
	 * @param targetW
	 * @param targetH
	 * @throws Exception
	 */
	public static boolean createThumbnail(String soruce, String target, int targetW, int targetH) throws Exception, ImageFormatException {
		
		if ( ! checkException(soruce) ) {
			return false;
		}
        
		Image imgSource = new ImageIcon(soruce).getImage();
		int width = imgSource.getWidth(null);
		int height = imgSource.getHeight(null);
		
		float rate = (new Float(width).floatValue() / new Float(height).floatValue());
		float targetRate = (new Float(targetW).floatValue() / new Float(targetH).floatValue());
		float resultW = (new Float(targetH).floatValue() / height) * width;
		float resultH = (new Float(targetW).floatValue() / width) * height;
		
		
		if (rate - targetRate >= 0) {
			createThumbnail(imgSource, target, targetW, Math.round(resultH));
		}
		else if (rate - targetRate < 0) {
			createThumbnail(imgSource, target, Math.round(resultW), targetH);
		}
		
		return true;
	}
	
	/**
	 * 결과물의 폭을 알때 높이를 비율에 맞게 조절
	 * @param soruce
	 * @param target
	 * @param targetW
	 * @throws Exception
	 */
	public static boolean createThumbnailW(String soruce, String target, int targetW) throws Exception {
		
		if ( ! checkException(soruce) ) {
			return false;
		}
		
		Image imgSource = new ImageIcon(soruce).getImage();
		int width = imgSource.getWidth(null);
		int height = imgSource.getHeight(null);
		
		float result = (new Float(targetW).floatValue() / width) * height;
		createThumbnail(imgSource, target, targetW, Math.round(result));
		
		return true;
	}
	
	/**
	 * 결과물의 높이를 알때 폭을 비율에 맞게 조절
	 * @param soruce
	 * @param target
	 * @param targetH
	 * @throws Exception
	 */
	public static boolean createThumbnailH(String soruce, String target, int targetH) throws Exception {
		
		if ( ! checkException(soruce) ) {
			return false;
		}
		
		Image imgSource = new ImageIcon(soruce).getImage();
		int width = imgSource.getWidth(null);
		int height = imgSource.getHeight(null);
		
		float result = (new Float(targetH).floatValue() / height) * width;
		createThumbnail(imgSource, target, Math.round(result), targetH);
		
		return true;
	}
}
