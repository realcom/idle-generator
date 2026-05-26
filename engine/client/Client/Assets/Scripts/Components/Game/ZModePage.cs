public abstract class ZModePage : ZEventBehaviour
{
    public abstract void InitializeUsingToken(string[] tokens);
    public abstract void OnVisible();
    public abstract void OnHide();
}
