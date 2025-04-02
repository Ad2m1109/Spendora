import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os  # Import os to access environment variables

def send_verification_email(email, code):
    sender_email = "spendaura85@gmail.com"
    sender_password = os.getenv("EMAIL_APP_PASSWORD")  # Retrieve app password from environment variable

    print(f"DEBUG: EMAIL_APP_PASSWORD={sender_password}")  # Debugging line

    if not sender_password:
        raise Exception("App password for email is not set in environment variables.")

    subject = "Email Verification Code"
    body = f"Your verification code is: {code}"

    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, email, msg.as_string())
        server.quit()
    except Exception as e:
        raise Exception(f"Failed to send email: {str(e)}")
