﻿using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using Microsoft.Owin;
using Urchin.Server.Owin.Extensions;
using Urchin.Server.Shared.DataContracts;
using Urchin.Server.Shared.Interfaces;

namespace Urchin.Server.Owin.Middleware
{
    public class VersionEndpoint: ApiBase
    {
        private readonly IRuleData _ruleData;
        private readonly PathString _path;

        public VersionEndpoint(
            IRuleData ruleData)
        {
            _ruleData = ruleData;
            _path = new PathString("/version/{version}");
        }

        public Task Invoke(IOwinContext context, Func<Task> next)
        {
            var request = context.Request;
            if (!_path.IsWildcardMatch(request.Path))
                return next.Invoke();

            try
            {
                var pathSegmnts = request.Path.Value
                    .Split('/')
                    .Where(p => !string.IsNullOrWhiteSpace(p))
                    .Select(HttpUtility.UrlDecode)
                    .ToArray();

                if (pathSegmnts.Length < 2)
                    throw new HttpException((int)HttpStatusCode.BadRequest, "Path has too few segments. Expecting " + _path.Value);

                var versionText = pathSegmnts[1];
                int version;
                if (!int.TryParse(versionText, out version))
                    throw new HttpException((int)HttpStatusCode.BadRequest, "Version must be a number. Expecting " + _path.Value);

                if (version < 1)
                    throw new HttpException((int)HttpStatusCode.BadRequest, "Version must be a number greater than zero.");

                if (request.Method == "PUT")
                    return RenameVersion(context, version);

                if (request.Method == "DELETE")
                    return DeleteVersion(context, version);
            }
            catch (Exception ex)
            {
                if (ex is HttpException) throw;
                return Json(context, new PostResponseDto { Success = false, ErrorMessage = ex.Message });
            }

            return next.Invoke();
        }

        private Task RenameVersion(IOwinContext context, int version)
        {
            var clientCredentials = context.Get<IClientCredentials>("ClientCredentials");
            _ruleData.RenameVersion(clientCredentials, version);
            return Json(context, new PostResponseDto { Success = true });
        }

        private Task DeleteVersion(IOwinContext context, int version)
        {
            var clientCredentials = context.Get<IClientCredentials>("ClientCredentials");
            _ruleData.DeleteVersion(clientCredentials, version);
            return Json(context, new PostResponseDto { Success = true });
        }
    }
}