import re

def extract_payment_amount(file_path):
    # Open the file
    with open(file_path, 'r') as file:
        # Read the content
        content = file.read()
        
        # Define the pattern to extract the payment amount
        pattern = r'Rs:(\d+\.\d{2})'
        
        # Search for the pattern in the content
        match = re.search(pattern, content)
        
        # If match is found, extract the payment amount
        if match:
            payment_amount = float(match.group(1))
            return payment_amount
        else:
            return None

# Path to the text file
file_path = 'messages.txt'

# Extract payment amount
payment_amount = extract_payment_amount(file_path)

# Print the payment amount
if payment_amount is not None:
    print("Payment amount:", payment_amount)
else:
    print("No payment amount found in the file.")
