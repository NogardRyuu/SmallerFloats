# SmallerFloats
This GDScript project adds functions that can convert floating point values into integer values and vice-versa, in order to allow bit manipulation on float. Theses integers values that represents float values (that are float 32) can be converted into `float 16` or `float 24` and back.

## Usage

Example of usage of some functions:

```GDScript
var original_float : float  = 65504     # (2 − 2^(−10)) * 2^15
var fp16                    = SmallerFloats.float_to_fp16_as_int(original_float)
var fp32_from_fp16          = SmallerFloats.fp16_as_int_to_float(fp16)

print("Original Float 32: %f\nFloat 16 as integer: %d\nFloat 16 back to Float 32: %f" % [original_float, fp16, fp32_from_fp16])

original_float      = 16776704      # (2 − 2^(−14)) * 2^23
var fp24            = SmallerFloats.float_to_fp24_as_int(original_float)
var fp32_from_fp24  = SmallerFloats.fp24_as_int_to_float(fp24)

print("Original Float 32: %f\nFloat 24 as integer: %d\nFloat 24 back to Float 32: %f" % [original_float, fp24, fp32_from_fp24])
```

## Functions

### float_as_int
Converts the float bytes to int bytes (not the same as typecasting to integer).
### int_as_float
Converts the int bytes to float bytes (not the same as typecasting to float).
### float_to_fp24_as_int
Converts float 32 into float 24 by applying bit operations in order to discard the undesired bits.
### float_to_fp16_as_int
Converts float 32 into float 16 by applying bit operations in order to discard the undesired bits.
### fp24_as_int_to_float
Converts float 24 into float 32 by applying bit operations in order to position the bits into the correct places.
### fp16_as_int_to_float
Converts float 16 into float 32 by applying bit operations in order to position the bits into the correct places.

## Float specification

### 16-bit float

Also known as `half`, `half-precision 16-bit float`, `float 16`, `fp16` and `binary16` is a float format that occupies 16 bits. It's specified in the [IEEE 754 standard](https://ieeexplore.ieee.org/document/8766229) as:

| sign ( 1-bit )    | exponent ( 5-bit )    | mantissa ( 10-bit )   |
| ---               | ---                   | ---                   |
| 0                 | 0 1 1 0 0             | 0 1 0 0 0 0 0 0 0 0   |

### 24-bit float

Also known as `float 24` and `fp24` is a float format that occupies 24 bits. The project follows the [AMD specification](https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-32-taking-plunge-gpu):


| sign ( 1-bit )    | exponent ( 7-bit )    | mantissa ( 16-bit )               |
| ---               | ---                   | ---                               |
| 0                 | 0 1 1 1 1 0 0         | 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0   |
