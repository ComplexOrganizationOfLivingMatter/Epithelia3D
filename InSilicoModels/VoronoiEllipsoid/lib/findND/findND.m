function varargout=findND(X,varargin)
%Find non-zero elements in ND-arrays. Replicates all behavior from find.
% The syntax is equivalent to the built-in find, but extended to
% multi-dimensional input.
%
% [...] = findND(X,K) returns at most the first K indices. K must be a
% positive  scalar of any type.
%
% [...] = findND(X,K,side) returns either the first K or the last K
% inidices. The input side  must be a char, either 'first' or 'last'. The
% default behavior is 'first'.
%
% [I1,I2,I3,...,In] = findND(X,...) returns indices along all the
% dimensions of X.
%
% [I1,I2,I3,...,In,V] = findND(X,...) returns indices along all the
% dimensions of X, and additionally returns a vector containg the values.
%
% Compatibility:
% Matlab: should work on all releases (tested on R2017a and R2012b)
% Octave: tested on 4.2.1
% OS:     should work cross-platform
%
% Version: 1.0
% Date:    2017-09-11
% Author:  H.J. Wisselink
% Email=  'h_j_wisselink*alumnus_utwente_nl';
% Real_email = regexprep(Email,{'*','_'},{'@','.'})

%Parse inputs
narginchk(1,3);
validateattributes(X,{'numeric','logical'},{'nonempty'},1)
switch nargin
    case 1
        %[...] = findND(X);
        side='first';
        K=inf;
    case 2
        %[...] = findND(X,K);
        side='first';
        K=varargin{1};
        validateattributes(K,{'numeric','logical'},{'scalar','positive'},2)
    case 3
        %[...] = FIND(X,K,'first');
        K=varargin{1};
        validateattributes(K,{'numeric'},{'positive'},2)
        side=varargin{2};
        if ~isa(side,'char') ||...
                ~( strcmp(side,'first') || strcmp(side,'last'))
            error('Third input must be either ''first'' or ''last''.')
        end
end

%parse outputs
nDims=length(size(X));
nargoutchk(0,nDims+1);
%allowed outputs: 0, 1, nDims, nDims+1
if nargout>1 && nargout<nDims
    error('Incorrect number of output arguments.')
end

varargout=cell(nargout,1);
if nargout>nDims
    [ind,val]=find(X(:),K,side);
    [varargout{1:(end-1)}] = ind2sub(size(X),ind);
    varargout{end}=val;
else
    ind=find(X,K,side);%(:) add a few ms and is not needed with this syntax
    [varargout{:}] = ind2sub(size(X),ind);
end
end