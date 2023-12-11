function [crc,cfg,crctable] = crc16(octets,cfgin)
% Usage: [crc,cfg,crctable] = crc16(octets,cfgin)
%
% Compute CRC-16 of a vector of unsigned bytes
%
% octets.............input vector of unsigned bytes
% cfgin..............optional struct to customize CRC-16 parameters
%   poly.............scalar CRC polynomial [0-0xffff] (default=0x1021)
%   init.............scalar initial shift register value [0-0xffff] (default=0)
%   refin............bool input reflection [0 or 1] (default=0)
%   refout...........bool output reflection [0 or 1] (default=0)
%   xorout...........scalar XOR'd with final CRC before returning (default=0)
% crc................output: computed CRC-16
% cfg................output: struct of configuration used to compute CRC 
%   cfg contains the same members as cfgin input struct
% crctable...........output: lookup table for fast CRC calculation
%
% CRC default parameters:
%  - polynomial: 0x1021
%  - shift register seed: 0
%  - input reflection: no
%  - output reflection: no
%  - output Xor: no
%
% Examples:
%
%  1. CRC16 using default parameters corresponding to CRC-16/XMODEM:
%     crc = crc16(uint8('123456789'));
%     disp(dec2hex(crc))
%     31C3
%
%  2. CRC-16/KERMIT often identified as CRC-16/CCITT:
%     crc = crc16(uint8('123456789'), struct('refin',1,'refout',1));
%     disp(dec2hex(crc))
%     2189
%
%  3. CRC-16/MODBUS:
%     cfg = struct('poly',0x8005,'init',0xffff,'refin',1,'refout',1,'xorout',0);
%     crc = crc16(uint8('123456789'),cfg);
%     disp(dec2hex(crc))
%     4B37
%
% Compare to the following online calculators: 
%   http://www.sunshine2k.de/coding/javascript/crc/crc_js.html
%   https://crccalc.com/ 
%
% References:
%  https://reveng.sourceforge.io/crc-catalogue/16.htm
%  https://www.drdobbs.com/tools/understanding-crcs/184410177
%

    persistent Crc16Table
    persistent lastPoly

    % Validate inputs
    narginchk(0,2);
    if nargin == 0 || ~isa(cfgin,'struct')
        crc = zeros(0,1);
        cfg = struct();
        crctable = [];
        help crc16
        return
    elseif nargin == 1
        cfgin = struct();
    end

    % Setup algorithm parameters
    cfg = parse_inputs(cfgin,nargin);
    octets = double(uint8(octets)); % cast avoids bitxor() warnings

    % CRC LUT
    if isempty(Crc16Table) || length(Crc16Table) ~= 256 ...
      || isempty(lastPoly) || lastPoly ~= cfg.poly
        Crc16Table = buildTable(cfg.poly);
        crctable = Crc16Table;
    end

    % Input reflection
    if cfg.refin
        octets = reflect(octets);
    end

    % CRC-16
    ff = 255;
    ffff = 65535;
    crc = cfg.init;
    for ii=1:length(octets)
        idx = bitand(bitxor(bitshift(crc, -8), octets(ii)), ff);
        crc = bitand(bitxor(Crc16Table(idx + 1), bitshift(crc, 8)), ffff);
    end

    % Output reflection
    if cfg.refout
        crc = reflect(uint16(crc));
    end

    % Final XOR
    if cfg.xorout
        crc = bitxor(crc, cfg.xorout);
    end

end % function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate CRC16 fast lookup table
function lut = buildTable(poly)
    poly = double(poly);
    ffff = 65535;
    for ii=0:255
      reg = bitshift(ii, 8);
      for jj=1:8
        if bitshift(reg, -15)
          reg = bitand(bitxor(bitshift(reg,1), poly), ffff);
        else
          reg = bitand(bitshift(reg, 1), ffff);
        end
      end
      lut(ii + 1) = bitand(reg, ffff);
    end
end % function

% Build reflection table
function lut = buildReflectTable
    bin = decimal2binary(0:255);
    rev = bin(:,end:-1:1);
    lut = binary2decimal(rev);
end % function

% Convert byte array to binary array
function b = decimal2binary(d)
    b = zeros(numel(d),8);
    for kk = 7:-1:0
        b(:,8-kk) = bitand(d(:),2^kk) ~= 0;
    end
end % function

% Convert binary array to byte array
% b is N-by-8 (convert each row to a byte)
function d = binary2decimal(b)
    v = 2.^(7:-1:0);
    d = b * v(:);
end % function

% Bit-reverse array of bytes or array of uint16s
function ref = reflect(d)
    persistent reflTable
    if isempty(reflTable) || length(reflTable) ~=256
        reflTable = buildReflectTable();
    end

    if isa(d,'uint16')
        lo = bitand(d(:),255); % 0x00ff
        hi = bitshift(bitand(d(:),65280),-8); % 0xff00
        reflo = reflTable(lo(:)+1);
        refhi = reflTable(hi(:)+1);
        ref = 2^8 * reflo(:) + refhi(:);
    else  % treat as uint8
        ref = reflTable(d(:)+1);
    end
end % function

% Setup algorithm parameters
function cfg = parse_inputs(cfg,N)
    if N == 1
        cfg.poly = 4129; % 0x1021
        cfg.init = 0;
        cfg.refin = 0;
        cfg.refout = 0;
        cfg.xorout = 0;
    end
    if ~isfield(cfg,'poly')
        cfg.poly = 4129; % 0x1021
    end
    if ~isfield(cfg,'init')
        cfg.init = 0;
    end
    if ~isfield(cfg,'refin')
        cfg.refin = 0;
    end
    if ~isfield(cfg,'refout')
        cfg.refout = 0;
    end
    if ~isfield(cfg,'xorout')
        cfg.xorout = 0;
    end
end % function
