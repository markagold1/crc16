function [crc,cfgout,crctable] = crc16(octets,cfg)
% Usage: [crc,cfgout,crctable] = crc16(octets,cfg)
%
% Compute CRC-16 (CCITT) of a vector of unsigned bytes
%
% octets.............input vector of unsigned bytes
% cfg................optional struct to customize CRC-16 parameters
%   poly.............scalar CRC polynomial [0-0xffff] (default=0x1021)
%   init.............scalar initial shift register value [0-0xffff] (default=0)
%   refin............bool input reflection [0 or 1] (default=0)
%   refout...........bool output reflection [0 or 1] (default=0)
%   xorout...........scalar XOR'd with final CRC before returning (default=0)
% crc................output: computed CRC-16
% cfgout.............output: struct of configuration used to compute CRC 
%   cfgout contains the same members as cfg input struct
% crctable...........output: lookup table for fast CRC calculation
%
% CRC default parameters:
%  - polynomial: 0x1021
%  - shift register seed: 0
%  - input reflection: no
%  - output reflection: no
%  - output Xor: no
%
% Note: If the length of your data in bits is not an integer 
%       number of bytes, prepend 0 bits to get a multiple
%       of 8 bits.
%
% Example:
%
% in = hex2dec(['31';'32';'33';'34';'35';'36';'37';'38';'39'])
% crc = crc16(in);
% dec2hex(crc)
% ans =
%     '31C3'
%
% Compare to: 
%   http://www.sunshine2k.de/coding/javascript/crc/crc_js.html
% and/or:
%   https://reveng.sourceforge.io/crc-catalogue/16.htm
% and/or:
%   https://crccalc.com/ 
%
% Reference:
%  https://www.drdobbs.com/tools/understanding-crcs/184410177
%

    persistent Crc16Table
    persistent lastPoly

    % Inputs
    narginchk(1,2);
    if nargin == 1
        cfg = struct();
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
   cfgout = cfg;

    % CRC LUT
    if isempty(Crc16Table) || length(Crc16Table) ~= 256 ...
      || isempty(lastPoly) || lastPoly ~= cfg.poly
        Crc16Table = buildTable(cfg.poly);
        crctable = Crc16Table;
    end

    % Input reflection
    if cfg.refin
        octets = reflect(uint8(octets));
    end

    % CRC-16
    ff = 255;
    ffff = 65535;
    crc = cfg.init;
    for ii=1:length(octets)
        idx = bitand(bitxor(bitshift(crc, -8), octets(ii)), ff);
        crc = bitand(bitxor(Crc16Table(idx + 1), bitshift(crc, 8)), ffff);
    end
    crc = bitand(crc, ffff);

    % Output reflection
    if cfg.refout
        crc = reflect(uint16(crc));
    end

    % Final XOR
    if cfg.xorout
        crc = bitxor(crc, cfg.xorout);
    end

end % function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
