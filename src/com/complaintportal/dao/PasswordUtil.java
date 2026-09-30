package com.complaintportal.dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public final class PasswordUtil {

    private PasswordUtil() {
    }

    public static String hash(String password) {

        if (password == null) {
            throw new IllegalArgumentException("Password cannot be null.");
        }

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            byte[] bytes =
                md.digest(password.getBytes(StandardCharsets.UTF_8));

            StringBuilder sb = new StringBuilder(bytes.length * 2);

            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(
                "SHA-256 algorithm is not available.",
                e
            );
        }
    }

    public static boolean matches(String password, String storedHash) {

        if (password == null || storedHash == null) {
            return false;
        }

        String calculatedHash = hash(password);

        return MessageDigest.isEqual(
            calculatedHash.getBytes(StandardCharsets.UTF_8),
            storedHash.getBytes(StandardCharsets.UTF_8)
        );
    }
}