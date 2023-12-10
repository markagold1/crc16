# Table-based implementation of CRC16

CRC16 is a very readable implementation of CRC-16 compatible with MATLAB and GNU Octave. The algorithm is parameterized to support a large number of CRC-16 variants. The following parameters can be specified.
* poly - CRC polynomial specified as a 16-bit hex value (default=0x1021)
* init - Initial shift register value specified as a 16-bit hex value (default=0)
* refin - Boolean input reflection (default=false)
* refout - Boolean output reflection (default=false)
* xorout - Value to XOR with the final CRC before returning, specified as 16-bit hex (default=0)

The implementation uses only primitive functions without dependencies on MATLAB toolboxes or GNU Octave packages. Because of this it will likely run on most any version.  It has been tested with MATLAB versions R2019b, R2020b, and R2022b as well as GNU Octave versions 3.8.2, 6.4.2, and 8.3.0.

# Files
* crc16.m - Table-based CRC-16 algorithm
* test_crc16.m - Test harness which verifies the algorithm against Greg Cook's catalogue of parametrised CRC algorithms with 16 bits

> Written with [StackEdit](https://stackedit.io/).
