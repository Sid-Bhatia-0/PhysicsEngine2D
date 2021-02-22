abstract type AbstractStdShape{T} end

#####
# StdPoint
#####

struct StdPoint{T} <: AbstractStdShape{T} end

#####
# StdLine
#####

struct StdLine{T} <: AbstractStdShape{T}
    half_length::T
end

get_half_length(line::StdLine) = line.half_length

# head, tail, and vertices for StdLine
get_head(line::StdLine{T}) where {T} = SA.SVector(get_half_length(line), zero(T))
get_tail(line::StdLine{T}) where {T} = SA.SVector(-get_half_length(line), zero(T))
get_vertices(line::StdLine) = (get_tail(line), get_head(line))

# head, tail, and vertices for StdLine at arbitrary position
get_head(line::StdLine{T}, pos::SA.SVector{2, T}) where {T} = pos .+ get_head(line)
get_tail(line::StdLine{T}, pos::SA.SVector{2, T}) where {T} = pos .+ get_tail(line)
get_vertices(line::StdLine{T}, pos::SA.SVector{2, T}) where {T} = (get_tail(line, pos), get_head(line, pos))

# head, tail, and vertices for StdLine at arbitrary position and orientation
get_head(line::StdLine{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = pos .+ get_half_length(line) .* get_x_cap(axes)
get_tail(line::StdLine{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = pos .+ get_half_length(line) .* -get_x_cap(axes)
get_vertices(line::StdLine{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = (get_tail(line, pos, axes), get_head(line, pos, axes))

#####
# StdCircle
#####

struct StdCircle{T} <: AbstractStdShape{T}
    radius::T
end

get_radius(circle::StdCircle) = circle.radius

function get_area(circle::StdCircle{T}) where {T}
    radius = get_radius(circle)
    return convert(T, pi * radius * radius)
end

#####
# StdRect
#####

struct StdRect{T} <: AbstractStdShape{T}
    half_width::T
    half_height::T
end

get_half_width(rect::StdRect) = rect.half_width
get_half_height(rect::StdRect) = rect.half_height

get_width(rect::StdRect) = 2 * get_half_width(rect)
get_height(rect::StdRect) = 2 * get_half_height(rect)

# bottom_left, bottom_right, top_left, top_right, and vertices for StdRect
get_bottom_left(rect::StdRect) = SA.SVector(-get_half_width(rect), -get_half_height(rect))
get_bottom_right(rect::StdRect) = SA.SVector(get_half_width(rect), -get_half_height(rect))
get_top_right(rect::StdRect) = SA.SVector(get_half_width(rect), get_half_height(rect))
get_top_left(rect::StdRect) = SA.SVector(-get_half_width(rect), get_half_height(rect))
get_vertices(rect::StdRect{T}) where {T} = (get_bottom_left(rect), get_bottom_right(rect), get_top_right(rect), get_top_left(rect))

# bottom_left, bottom_right, top_left, top_right, and vertices for StdRect at arbitrary position
get_bottom_left(rect::StdRect{T}, pos::SA.SVector{2, T}) where {T} = pos .+ SA.SVector(-get_half_width(rect), -get_half_height(rect))
get_bottom_right(rect::StdRect{T}, pos::SA.SVector{2, T}) where {T} = pos .+ SA.SVector(get_half_width(rect), -get_half_height(rect))
get_top_right(rect::StdRect{T}, pos::SA.SVector{2, T}) where {T} = pos .+ SA.SVector(get_half_width(rect), get_half_height(rect))
get_top_left(rect::StdRect{T}, pos::SA.SVector{2, T}) where {T} = pos .+ SA.SVector(-get_half_width(rect), get_half_height(rect))
get_vertices(rect::StdRect{T}, pos::SA.SVector{2, T}) where {T} = (get_bottom_left(rect, pos), get_bottom_right(rect, pos), get_top_right(rect, pos), get_top_left(rect, pos))

# bottom_left, bottom_right, top_left, top_right, and vertices for StdRect at arbitrary position and orientation
get_bottom_left(rect::StdRect{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = pos .- get_half_width(rect) .* get_x_cap(axes) .- get_half_height(rect) .* get_y_cap(axes)
get_bottom_right(rect::StdRect{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = pos .+ get_half_width(rect) .* get_x_cap(axes) .- get_half_height(rect) .* get_y_cap(axes)
get_top_right(rect::StdRect{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = pos .+ get_half_width(rect) .* get_x_cap(axes) .+ get_half_height(rect) .* get_y_cap(axes)
get_top_left(rect::StdRect{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = pos .- get_half_width(rect) .* get_x_cap(axes) .+ get_half_height(rect) .* get_y_cap(axes)
get_vertices(rect::StdRect{T}, pos::SA.SVector{2, T}, axes::Axes{T}) where {T} = (get_bottom_left(rect, pos, axes), get_bottom_right(rect, pos, axes), get_top_right(rect, pos, axes), get_top_left(rect, pos, axes))

get_area(rect::StdRect{T}) where {T} = convert(T, 4 * get_half_width(rect) * get_half_height(rect))

get_normals(rect::StdRect{T}) where {T} = get_normals(rect, Axes{T}())

function get_normals(rect::StdRect{T}, axes::Axes{T}) where {T}
    x_cap = get_x_cap(axes)
    y_cap = get_y_cap(axes)
    return (-y_cap, x_cap, y_cap, -x_cap)
end
