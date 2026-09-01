--For use in development
--Reset the password for swzadmin to '1' using a SHA512 hash
UPDATE dwSecurityCredential SET 
	PasswordHash='qVl+BW5lANGKl2IAUDAFDEeXIKzxmAA2+2WtuxejptYaiqE4wPZdVFYUQE0tz5GE1pY9rEfvxcDFIhZutZ7T8A==', 
	PasswordSalt='JRbKWv4b97JGVXEVlIj8zw==' 
WHERE Id='78F94875-58F0-4091-BD36-01FF92D6B03C';
