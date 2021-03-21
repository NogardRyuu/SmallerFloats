class_name SmallerFloats

static func float_as_int(float_value : float) -> int:
	var float_bytes = var2bytes(float_value)
	# the top 32 bytes are discarded because it's apparently used to store the variable type
	return (float_bytes[7] << 24) | (float_bytes[6] << 16) | (float_bytes[5] << 8) | float_bytes[4]

static func int_as_float(int_value : int) -> float:
	var int_bytes = var2bytes(int_value)
	# 0x03 0x00 0x00 0x00 means float
	return bytes2var(PoolByteArray([0x3, 0x0, 0x0, 0x0, 
									int_bytes[4], int_bytes[5], int_bytes[6], int_bytes[7]]))

static func float_to_fp24_as_int(float_value : float) -> int:
	#	https://en.wikipedia.org/wiki/Bfloat16_floating-point_format
	#	AMD's fp24 format
	#	sign (1 bit) | exponent (7 bit) | fraction (16 bit)
	
	var float_value_as_int = float_as_int(float_value)
	# sign and the exponent msb
	var sign_and_exponent       = (float_value_as_int & 0b11000000000000000000000000000000)
	# 	exponent 6 lsbs and mandessa first 16 bytes (left to right)
	var exponents_and_mandessa  = (float_value_as_int & 0b00011111111111111111111000000000) << 1
	return sign_and_exponent | exponents_and_mandessa;

static func float_to_fp16_as_int(float_value : float) -> int:
	#	https://en.wikipedia.org/wiki/Half-precision_floating-point_format
	# 	sign (1 bit) | exponent (5 bit) | fraction (10 bit)
	
	var float_value_as_int = float_as_int(float_value)
	# 	sign and the exponent msb
	var sign_and_exponent       = (float_value_as_int & 0b11000000000000000000000000000000)
	# 	exponent 6 lsbs and mandessa first 16 bytes (left to right)
	var exponents_and_mandessa  = (float_value_as_int & 0b00000111111111111110000000000000) << 3
	return sign_and_exponent | exponents_and_mandessa;

static func fp24_as_int_to_float(fp24_value_as_int : int) -> float:
	#	https://en.wikipedia.org/wiki/Bfloat16_floating-point_format
	#	AMD's fp24 format
	# 	sign (1 bit) | exponent (7 bit) | fraction (16 bit)
	
	var sign_and_exponent       = (fp24_value_as_int & 0b11000000000000000000000000000000)
	var exponents_and_mandessa  = (fp24_value_as_int & 0b00111111111111111111111100000000) >> 1
	return int_as_float(sign_and_exponent | exponents_and_mandessa);

static func fp16_as_int_to_float(float16_as_int : int) -> float:
	#	https://en.wikipedia.org/wiki/Half-precision_floating-point_format
	# 	sign (1 bit) | exponent (5 bit) | fraction (10 bit)
	
	var sign_and_exponent       = (float16_as_int & 0b11000000000000000000000000000000)
	var exponents_and_mandessa  = (float16_as_int & 0b00111111111111110000000000000000) >>  3
	return int_as_float(sign_and_exponent | exponents_and_mandessa);
