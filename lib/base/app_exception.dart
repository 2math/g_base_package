class AppException extends Error{
    //Error codes must be < 300 , 300+ are for network errors
    static const int OFFLINE_ERROR = 226;
    static const int NO_CALL_METHOD_ERROR = 227;
    static const String DUPLICATE_DATA = "DUPLICATE_DATA";
    static const String UNSUPPORTED_VERSION = "UNSUPPORTED_VERSION";

    String error;
    int code;
    Object data;

    AppException({String errorMessage, int code, Object data}){
        this.error = errorMessage;
        this.code = code;
        this.data = data;
    }

    @override
    String toString() {
        return 'AppException{error: $error, code: $code, data: $data}';
    }

    @override
    bool operator ==(Object other) =>
            identical(this, other) ||
                    other is AppException &&
                            runtimeType == other.runtimeType &&
                            error == other.error &&
                            code == other.code &&
                            data == other.data;

    @override
    int get hashCode =>
            error.hashCode ^
            code.hashCode ^
            data.hashCode;


}