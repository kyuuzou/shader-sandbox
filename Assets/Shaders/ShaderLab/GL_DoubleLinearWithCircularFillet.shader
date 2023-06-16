Shader "Book of Shaders/GL_DoubleLinearWithCircularFillet"
{
    Properties
    {
        _A ("A", Range(0.0, 1.0)) = 0.5
        _B ("B", Range(0.0, 1.0)) = 0.5
        _R ("R", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            //--------------------------------------------------------
            // Joining Two Lines with a Circular Arc Fillet
            // Adapted from Robert D. Miller / Graphics Gems III.

            float arcStartAngle;
            float arcEndAngle;
            float arcStartX, arcStartY;
            float arcEndX, arcEndY;
            float arcCenterX, arcCenterY;
            float arcRadius;

            float _A, _B, _R;

            //------------------------------------------
            // Return signed distance from line Ax + By + C = 0 to point P.
            float linetopoint(float a, float b, float c, float ptx, float pty) {
                float lp = 0.0;
                float d = sqrt((a * a) + (b * b));
                if (d != 0.0) {
                    lp = (a * ptx + b * pty + c) / d;
                }
                return lp;
            }

            //------------------------------------------
            // Compute the parameters of a circular arc 
            // fillet between lines L1 (p1 to p2) and
            // L2 (p3 to p4) with radius R.  
            // 
            void computeFilletParameters(
                float p1x, float p1y,
                float p2x, float p2y,
                float p3x, float p3y,
                float p4x, float p4y,
                float r) {

                float c1 = p2x * p1y - p1x * p2y;
                float a1 = p2y - p1y;
                float b1 = p1x - p2x;
                float c2 = p4x * p3y - p3x * p4y;
                float a2 = p4y - p3y;
                float b2 = p3x - p4x;
                if ((a1 * b2) == (a2 * b1)) {
                    /* Parallel or coincident lines */
                    return;
                }

                float d1, d2;
                float mPx, mPy;
                mPx = (p3x + p4x) / 2.0;
                mPy = (p3y + p4y) / 2.0;
                d1 = linetopoint(a1, b1, c1, mPx, mPy); /* Find distance p1p2 to p3 */
                if (d1 == 0.0) {
                    return;
                }
                mPx = (p1x + p2x) / 2.0;
                mPy = (p1y + p2y) / 2.0;
                d2 = linetopoint(a2, b2, c2, mPx, mPy); /* Find distance p3p4 to p2 */
                if (d2 == 0.0) {
                    return;
                }

                float c1p, c2p, d;
                float rr = r;
                if (d1 <= 0.0) {
                    rr = -rr;
                }
                c1p = c1 - rr * sqrt((a1 * a1) + (b1 * b1)); /* Line parallel l1 at d */
                rr = r;
                if (d2 <= 0.0) {
                    rr = -rr;
                }
                c2p = c2 - rr * sqrt((a2 * a2) + (b2 * b2)); /* Line parallel l2 at d */
                d = (a1 * b2) - (a2 * b1);

                float pCx = (c2p * b1 - c1p * b2) / d; /* Intersect constructed lines */
                float pCy = (c1p * a2 - c2p * a1) / d; /* to find center of arc */
                float pAx = 0;
                float pAy = 0;
                float pBx = 0;
                float pBy = 0;
                float dP, cP;

                dP = (a1 * a1) + (b1 * b1); /* Clip or extend lines as required */
                if (dP != 0.0) {
                    cP = a1 * pCy - b1 * pCx;
                    pAx = (-a1 * c1 - b1 * cP) / dP;
                    pAy = (a1 * cP - b1 * c1) / dP;
                }
                dP = (a2 * a2) + (b2 * b2);
                if (dP != 0.0) {
                    cP = a2 * pCy - b2 * pCx;
                    pBx = (-a2 * c2 - b2 * cP) / dP;
                    pBy = (a2 * cP - b2 * c2) / dP;
                }

                float gv1x = pAx - pCx;
                float gv1y = pAy - pCy;
                float gv2x = pBx - pCx;
                float gv2y = pBy - pCy;

                float arcStart = (float) atan2(gv1y, gv1x);
                float arcAngle = 0.0;
                float dd = (float) sqrt(((gv1x * gv1x) + (gv1y * gv1y)) * ((gv2x * gv2x) + (gv2y * gv2y)));
                if (dd != (float) 0.0) {
                    arcAngle = (acos((gv1x * gv2x + gv1y * gv2y) / dd));
                }
                float crossProduct = (gv1x * gv2y - gv2x * gv1y);
                if (crossProduct < 0.0) {
                    arcStart -= arcAngle;
                }

                float arc1 = arcStart;
                float arc2 = arcStart + arcAngle;
                if (crossProduct < 0.0) {
                    arc1 = arcStart + arcAngle;
                    arc2 = arcStart;
                }

                arcCenterX = pCx;
                arcCenterY = pCy;
                arcStartAngle = arc1;
                arcEndAngle = arc2;
                arcRadius = r;
                arcStartX = arcCenterX + arcRadius * cos(arcStartAngle);
                arcStartY = arcCenterY + arcRadius * sin(arcStartAngle);
                arcEndX = arcCenterX + arcRadius * cos(arcEndAngle);
                arcEndY = arcCenterY + arcRadius * sin(arcEndAngle);
            }

            //--------------------------------------------------------
            float circularFillet(float x, float a, float b, float R) {

                float epsilon = 0.00001;
                float min_param_a = 0.0 + epsilon;
                float max_param_a = 1.0 - epsilon;
                float min_param_b = 0.0 + epsilon;
                float max_param_b = 1.0 - epsilon;
                a = max(min_param_a, min(max_param_a, a));
                b = max(min_param_b, min(max_param_b, b));

                computeFilletParameters(0, 0, a, b, a, b, 1, 1, R);
                float t = 0;
                float y = 0;
                x = max(0, min(1, x));

                if (x <= arcStartX) {
                    t = x / arcStartX;
                    y = t * arcStartY;
                } else if (x >= arcEndX) {
                    t = (x - arcEndX) / (1 - arcEndX);
                    y = arcEndY + t * (1 - arcEndY);
                } else {
                    if (x >= arcCenterX) {
                        y = arcCenterY - sqrt(pow(arcRadius, 2) - pow(x - arcCenterX, 2));
                    } else {
                        y = arcCenterY + sqrt(pow(arcRadius, 2) - pow(x - arcCenterX, 2));
                    }
                }
                return y;
            }

            float plot(float2 st, float pct) 
            {
                return smoothstep(pct - 0.01, pct, st.y) - smoothstep(pct, pct + 0.01, st.y);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 st = i.uv.xy/_ScreenParams.w;
                float y = circularFillet(st.x, _A, _B, _R);

                float3 color = float3(y, y, y);
                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
