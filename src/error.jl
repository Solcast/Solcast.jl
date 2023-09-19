struct ValueError <: Exception
    msg::AbstractString
end

struct InvalidResponse <: Exception
    msg::AbstractString
end

invalid_response_error = InvalidResponse("Invalid response: There is no body to parse as JSON.")
