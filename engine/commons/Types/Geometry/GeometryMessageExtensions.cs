using System;

namespace Commons.Types.Geometry
{
    public static class GeometryMessageExtensions
    {
        public static IGeometry ToGeometry(this GeometryMessage g)
        {
            return g.GeometryCase switch
            {
                GeometryMessage.GeometryOneofCase.Line => (Line)g.Line,
                GeometryMessage.GeometryOneofCase.BoundingBox => (BoundingBox)g.BoundingBox,
                GeometryMessage.GeometryOneofCase.Circle => (Circle)g.Circle,
                GeometryMessage.GeometryOneofCase.CircleSector => (CircleSector)g.CircleSector,
                GeometryMessage.GeometryOneofCase.Triangle => (Triangle)g.Triangle,
                GeometryMessage.GeometryOneofCase.Rectangle => (Rectangle)g.Rectangle,
                _ => throw new NotImplementedException(),
            };
        }
        
        public static GeometryMessage ToGeometryMessage(this IGeometry g)
        {
            return g.GeometryType switch
            {
                IGeometry.Type.Line => new GeometryMessage { Line = (Line)g },
                IGeometry.Type.BoundingBox => new GeometryMessage { BoundingBox = (BoundingBox)g },
                IGeometry.Type.Circle => new GeometryMessage { Circle = (Circle)g },
                IGeometry.Type.CircleSector => new GeometryMessage { CircleSector = (CircleSector)g },
                IGeometry.Type.Triangle => new GeometryMessage { Triangle = (Triangle)g },
                IGeometry.Type.Rectangle => new GeometryMessage { Rectangle = (Rectangle)g },
                _ => throw new NotImplementedException(),
            };
        }
    }
}
