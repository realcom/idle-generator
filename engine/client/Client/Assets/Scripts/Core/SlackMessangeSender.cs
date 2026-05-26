using System.Diagnostics;
using System.IO;
using System.Net.Http;
using UnityEngine;

#if UNITY_EDITOR
using System.Text;
using System.Threading.Tasks;
using UnityEditor;

namespace Core
{
    public static class SlackMessageSender
    {
        //노예 1호기
        const string SLACK_BOT_TOKEN = "xoxb-907631150854-9532573773815-ttndeTWi32L0S3WRWfM3Xiko";
        //채널 version_log
        const string VERSION_LOG_CHANNEL_ID = "C022Z30R4RJ";
        
        private static readonly StringBuilder _stringBuilder = new();
            
        public static void Send(string title, StringBuilder messageBuilder, string channelID = null, string botToken = null)
        {
            if (string.IsNullOrEmpty(title))
                return;

            _stringBuilder.Clear();
            _stringBuilder.AppendLine($":hamdance::hamdance::hamdance: *[돌격 햄스터]* :hamdance::hamdance::hamdance: Author: {GetGitUserName()}");
            _stringBuilder.AppendLine(title);
            _stringBuilder.AppendLine();
            _stringBuilder.Append(messageBuilder);
            
            channelID ??= VERSION_LOG_CHANNEL_ID;
            botToken ??= SLACK_BOT_TOKEN;
            
            SendMessageToSlackAsync(botToken, channelID, _stringBuilder.ToString().Replace("\r", "")).ConfigureAwait(false);
        }

        private static async Task SendMessageToSlackAsync(string botToken, string channelID, string str)
        {
            using var httpClient = new HttpClient();
            var postData = new StringContent(
                $"{{\"channel\":\"{channelID}\", \"text\":\"{str}\"}}",
                Encoding.UTF8,
                "application/json");

            httpClient.DefaultRequestHeaders.Authorization = 
                new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", botToken);

            var response = await httpClient.PostAsync("https://slack.com/api/chat.postMessage", postData);

            var responseContent = await response.Content.ReadAsStringAsync();
            // 여기에서 응답 내용을 확인하거나 로깅할 수 있습니다.
            System.Console.WriteLine(responseContent);
        }
        
        public static string GetLocalHeadCommit()
        {
            return GetGitCommandResult("log --pretty=format:\"%h [%an] - %s\" -n 1 HEAD");
        }

        public static string GetGitUserName()
        {
            return GetGitCommandResult("config user.name");
        }

        private static string GetGitCommandResult(string command)
        {
            var info = new DirectoryInfo(Application.dataPath);
            info = info.Parent?.Parent;

            if (info is null)
                return string.Empty;
        
            var startInfo = new ProcessStartInfo("git")
            {
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true,
                WorkingDirectory = info.FullName,
                Arguments = command
            };

            using var process = Process.Start(startInfo);
            if (process is null)
                return "Can't start process";
        
            using var error = process.StandardError;
            if (error.ReadToEnd() is { Length: > 0 } errorText)
                return errorText.Trim();

            using var reader = process.StandardOutput;
            var result = reader.ReadToEnd();
            return result.Trim();
        }
        
        
    }
}
#endif
