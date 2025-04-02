from google.oauth2 import id_token
from google.auth.transport import requests

def verify_google_token(token):
    try:
        CLIENT_ID = "1094534390706-bjt8nkpk9hfkq8thcma1kff64k1rb8v2.apps.googleusercontent.com"
        id_info = id_token.verify_oauth2_token(token, requests.Request(), CLIENT_ID)

        # Verify the token is issued by Google
        if id_info['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise ValueError('Wrong issuer.')

        # Return user information
        return {
            'email': id_info['email'],
            'name': id_info.get('name', 'Google User')
        }
    except Exception as e:
        print(f"Error verifying Google token: {e}")
        return None
