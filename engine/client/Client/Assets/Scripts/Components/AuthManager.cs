using UnityEngine;
using System;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

#if UNITY_ANDROID
using GooglePlayGames;
using GooglePlayGames.BasicApi;
#endif

public class AuthManager : MonoBehaviour
{
    public const string GuestDomain = "@hamster.puzzlemonsters.io";
    public const string AuthPrefKey = Constants.Key.GUEST_SNS_ID;
    private static bool _loggedMissingSdk;
    
    private static AuthManager _singleton;
    public static AuthManager Get()
    {
        if (_singleton == null)
        {
            _singleton = new GameObject("[AuthManager]").AddComponent<AuthManager>();
        }

        return _singleton;
    }
    
    public static async Task InitFirebase()
    {
        await Task.CompletedTask;
        LogOptionalSdkSkip("Firebase auth init");
    }

    public static void SigninPlayGame()
    {
#if UNITY_ANDROID        
        PlayGamesPlatform.Instance.Authenticate(status =>
        {
            if (status == SignInStatus.Success) {
                // Continue with Play Games Services
            } else {
                // Disable your integration with Play Games Services or show a login button
                // to ask users to sign-in. Clicking it should call
                // PlayGamesPlatform.Instance.ManuallyAuthenticate(ProcessAuthentication).
            }
        });
#endif
    }
    


    public static string MakePassword(string snsId)
    {
        using var sha = SHA256.Create();
        var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(snsId));
        var sb = new StringBuilder();
        foreach (var b in bytes) sb.Append(b.ToString("x2"));
        return sb.ToString(); // 64자리 헥사
    }

 
    public static void RegisterFirebase()
    {
        LogOptionalSdkSkip("Firebase guest registration");
    }

    private static void LogOptionalSdkSkip(string operation)
    {
        if (_loggedMissingSdk)
            return;

        _loggedMissingSdk = true;
        Debug.LogWarning($"[AuthManager] {operation} skipped because the Firebase SDK is not installed in this client workspace.");
    }
}
