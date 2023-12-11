function test_crc16()
% Usage: test_crc16()
%
% Test our CRC16 implementation against reference data in CRC RevEng's
% catalogue of parametrised CRC algorithms with 16 bits
% https://reveng.sourceforge.io/crc-catalogue/16.htm
%
 
    in = uint8('123456789');
    lines = reference();
    for kk = 1:size(lines,1)
        eval(lines(kk,:));
        cfg = struct();
        cfg.poly = Poly;
        cfg.init = init;
        cfg.refin = refin;
        cfg.refout = refout;
        cfg.xorout = xorout;
        [crc,cfgout,crctable] = crc16(in,cfg);
        nm = repmat(' ',1,32);
        nm(1:numel(char(name))) = char(name);
        if crc == double(check)
            fprintf(1,'%s: PASS\n', nm);
        else
            fprintf(1,'%s: FAIL\n', nm);
        end
    end

end % function

% Reference CRC16 data from https://reveng.sourceforge.io/crc-catalogue/16.htm
function ref = reference()
    ref = [
        'width=16;Poly=0x8005;init=0x0000;refin=true;refout=true;xorout=0x0000;check=0xbb3d;residue=0x0000;name="CRC-16/ARC";              '
        'width=16;Poly=0xc867;init=0xffff;refin=false;refout=false;xorout=0x0000;check=0x4c06;residue=0x0000;name="CRC-16/CDMA2000";       '
        'width=16;Poly=0x8005;init=0xffff;refin=false;refout=false;xorout=0x0000;check=0xaee7;residue=0x0000;name="CRC-16/CMS";            '
        'width=16;Poly=0x8005;init=0x800d;refin=false;refout=false;xorout=0x0000;check=0x9ecf;residue=0x0000;name="CRC-16/DDS-110";        '
        'width=16;Poly=0x0589;init=0x0000;refin=false;refout=false;xorout=0x0001;check=0x007e;residue=0x0589;name="CRC-16/DECT-R";         '
        'width=16;Poly=0x0589;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0x007f;residue=0x0000;name="CRC-16/DECT-X";         '
        'width=16;Poly=0x3d65;init=0x0000;refin=true;refout=true;xorout=0xffff;check=0xea82;residue=0x66c5;name="CRC-16/DNP";              '
        'width=16;Poly=0x3d65;init=0x0000;refin=false;refout=false;xorout=0xffff;check=0xc2b7;residue=0xa366;name="CRC-16/EN-13757";       '
        'width=16;Poly=0x1021;init=0xffff;refin=false;refout=false;xorout=0xffff;check=0xd64e;residue=0x1d0f;name="CRC-16/GENIBUS";        '
        'width=16;Poly=0x1021;init=0x0000;refin=false;refout=false;xorout=0xffff;check=0xce3c;residue=0x1d0f;name="CRC-16/GSM";            '
        'width=16;Poly=0x1021;init=0xffff;refin=false;refout=false;xorout=0x0000;check=0x29b1;residue=0x0000;name="CRC-16/IBM-3740";       '
        'width=16;Poly=0x1021;init=0xffff;refin=true;refout=true;xorout=0xffff;check=0x906e;residue=0xf0b8;name="CRC-16/IBM-SDLC";         '
        'width=16;Poly=0x1021;init=0xc6c6;refin=true;refout=true;xorout=0x0000;check=0xbf05;residue=0x0000;name="CRC-16/ISO-IEC-14443-3-A";'
        'width=16;Poly=0x1021;init=0x0000;refin=true;refout=true;xorout=0x0000;check=0x2189;residue=0x0000;name="CRC-16/KERMIT";           '
        'width=16;Poly=0x6f63;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0xbdf4;residue=0x0000;name="CRC-16/LJ1200";         '
        'width=16;Poly=0x5935;init=0xffff;refin=false;refout=false;xorout=0x0000;check=0x772b;residue=0x0000;name="CRC-16/M17";            '
        'width=16;Poly=0x8005;init=0x0000;refin=true;refout=true;xorout=0xffff;check=0x44c2;residue=0xb001;name="CRC-16/MAXIM-DOW";        '
        'width=16;Poly=0x1021;init=0xffff;refin=true;refout=true;xorout=0x0000;check=0x6f91;residue=0x0000;name="CRC-16/MCRF4XX";          '
        'width=16;Poly=0x8005;init=0xffff;refin=true;refout=true;xorout=0x0000;check=0x4b37;residue=0x0000;name="CRC-16/MODBUS";           '
        'width=16;Poly=0x080b;init=0xffff;refin=true;refout=true;xorout=0x0000;check=0xa066;residue=0x0000;name="CRC-16/NRSC-5";           '
        'width=16;Poly=0x5935;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0x5d38;residue=0x0000;name="CRC-16/OPENSAFETY-A";   '
        'width=16;Poly=0x755b;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0x20fe;residue=0x0000;name="CRC-16/OPENSAFETY-B";   '
        'width=16;Poly=0x1dcf;init=0xffff;refin=false;refout=false;xorout=0xffff;check=0xa819;residue=0xe394;name="CRC-16/PROFIBUS";       '
        'width=16;Poly=0x1021;init=0xb2aa;refin=true;refout=true;xorout=0x0000;check=0x63d0;residue=0x0000;name="CRC-16/RIELLO";           '
        'width=16;Poly=0x1021;init=0x1d0f;refin=false;refout=false;xorout=0x0000;check=0xe5cc;residue=0x0000;name="CRC-16/SPI-FUJITSU";    '
        'width=16;Poly=0x8bb7;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0xd0db;residue=0x0000;name="CRC-16/T10-DIF";        '
        'width=16;Poly=0xa097;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0x0fb3;residue=0x0000;name="CRC-16/TELEDISK";       '
        'width=16;Poly=0x1021;init=0x89ec;refin=true;refout=true;xorout=0x0000;check=0x26b1;residue=0x0000;name="CRC-16/TMS37157";         '
        'width=16;Poly=0x8005;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0xfee8;residue=0x0000;name="CRC-16/UMTS";           '
        'width=16;Poly=0x8005;init=0xffff;refin=true;refout=true;xorout=0xffff;check=0xb4c8;residue=0xb001;name="CRC-16/USB";              '
        'width=16;Poly=0x1021;init=0x0000;refin=false;refout=false;xorout=0x0000;check=0x31c3;residue=0x0000;name="CRC-16/XMODEM";         '
    ];
end % function
