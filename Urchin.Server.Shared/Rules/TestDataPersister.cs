﻿using System;
using System.Collections.Generic;
using System.Linq;
using Urchin.Server.Shared.DataContracts;
using Urchin.Server.Shared.Interfaces;

namespace Urchin.Server.Shared.Rules
{
    public class TestDataPersister: IPersister
    {
        private readonly string _defaultEnvironment;
        private readonly List<RuleDto> _rules;
        private readonly List<EnvironmentDto> _environments;

        public TestDataPersister()
        {
            _defaultEnvironment = "Development";

            _rules = new List<RuleDto>
            {
                new RuleDto
                {
                    RuleName = "DevelopmentEnvironment",
                    Environment = "Development",
                    ConfigurationData = "{\"debug\":true}"
                },
                new RuleDto
                {
                    RuleName = "Root",
                    ConfigurationData =
                        "{\"environment\":\"($environment$)\",\"machine\":\"($machine$)\",\"application\":\"($application$)\",\"debug\":false}"
                }
            };

            _environments = new List<EnvironmentDto>
            {
                new EnvironmentDto 
                {
                    EnvironmentName = "Production", Machines = new List<string>(),
                    SecurityRules = new List<SecurityRuleDto>
                    {
                        new SecurityRuleDto
                        {
                            AllowedIpStart = "192.168.0.1",
                            AllowedIpEnd = "192.168.0.4"
                        }
                    }
                },
                new EnvironmentDto 
                {
                    EnvironmentName = "Staging", Machines = new List<string>(),
                    SecurityRules = new List<SecurityRuleDto>{}
                },
                new EnvironmentDto 
                {
                    EnvironmentName = "Integration", Machines = new List<string>(),
                    SecurityRules = new List<SecurityRuleDto>{}
                },
                new EnvironmentDto 
                {
                    EnvironmentName = "Test", Machines = new List<string>(),
                    SecurityRules = new List<SecurityRuleDto>{}
                }
            };
        }

        public bool SupportsVersioning { get { return false; } }

        public List<int> GetVersionNumbers() 
        { 
            return null; 
        }

        public string GetDefaultEnvironment()
        {
            return _defaultEnvironment;
        }

        public void SetDefaultEnvironment(string name)
        {
        }

        public IEnumerable<string> GetRuleNames(int version)
        {
            return _rules.Select(r => r.RuleName);
        }

        public RuleDto GetRule(int version, string name)
        {
            return _rules.FirstOrDefault(r => string.Equals(r.RuleName, name, StringComparison.InvariantCultureIgnoreCase));
        }

        public IEnumerable<RuleDto> GetAllRules(int version)
        {
            return _rules;
        }

        public void DeleteRule(int version, string name)
        {
        }

        public void InsertOrUpdateRule(int version, RuleDto rule)
        {
        }

        public IEnumerable<string> GetEnvironmentNames()
        {
            return _environments.Select(r => r.EnvironmentName);
        }

        public EnvironmentDto GetEnvironment(string name)
        {
            return _environments.FirstOrDefault(e => string.Equals(e.EnvironmentName, name, StringComparison.InvariantCultureIgnoreCase));
        }

        public IEnumerable<EnvironmentDto> GetAllEnvironments()
        {
            return _environments;
        }

        public void DeleteEnvironment(string name)
        {
        }

        public void InsertOrUpdateEnvironment(EnvironmentDto environment)
        {
        }
    }
}
