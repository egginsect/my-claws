# QA Engineer Task: Comprehensive Claimwise Testing

You are a Senior QA Engineer conducting comprehensive testing of Claimwise.

**PROJECT OVERVIEW:**
Claimwise is an AI-powered coverage copilot with:
1. **MCP Server** (Python FastAPI at /api/mcp.py) - Backend service exposing tools for coverage chat
2. **Next.js Frontend** - Chat interface, claims management, transactions

**YOUR MISSION:**
Conduct thorough testing of BOTH components and document all findings.

## Phase 1: MCP Server Testing

**Location:** /home/node/.openclaw/workspace/claimwise/api/mcp.py

1. **API Endpoint Testing:**
   - Test all MCP protocol endpoints
   - Verify tool registration and discovery
   - Test each tool's functionality (coverage lookup, claim drafting, transaction queries)
   - Check error handling for invalid inputs
   - Test authentication flows (api/auth.py)

2. **Integration Testing:**
   - Verify Supabase connections
   - Test Plaid API integrations
   - Validate OpenAI/LLM calls
   - Check vector store operations

3. **Performance & Reliability:**
   - Response times for typical queries
   - Error rate analysis
   - Memory/resource usage
   - Concurrent request handling

4. **Security Review:**
   - Authentication mechanisms
   - Input validation
   - API key handling
   - SQL injection risks

## Phase 2: Frontend/Chat Interface Testing

**Note:** There's already a test report showing critical build errors (see: /home/node/.openclaw/workspace/claimwise-frontend-test-report.md)

1. **Build & Deployment:**
   - Attempt to fix the Tailwind CSS webpack error
   - Get the dev server running
   - Document any remaining build issues

2. **Chat Interface (MobileChat component):**
   - UI responsiveness and layout
   - Message streaming functionality
   - Citation pills display
   - Error states
   - Loading states
   - Mobile vs desktop experience

3. **Core Functionality:**
   - Coverage Chat flow
   - Claims creation/tracking
   - Transaction viewing/filtering
   - Settings/integrations
   - Navigation between screens

4. **UX Issues:**
   - Confusing workflows
   - Missing features
   - Unclear error messages
   - Accessibility problems

5. **Integration Testing:**
   - Frontend ↔ MCP server communication
   - Real-time updates
   - Session management
   - OAuth flows (Google, etc.)

## Deliverable Format:

Create a comprehensive QA report as: **/home/node/.openclaw/workspace/claimwise-qa-report.md**

Structure:
```
# Claimwise QA Test Report

## Executive Summary
- Overall health score
- Critical blockers
- High-priority issues
- Quick wins

## MCP Server Findings
### Critical Issues
### High Priority
### Medium Priority
### Low Priority

## Frontend Findings
### Critical Issues
### High Priority
### Medium Priority
### Low Priority

## Security Concerns
(List any security vulnerabilities)

## Performance Issues
(Response times, bottlenecks)

## UX Problems
(User experience pain points)

## Recommendations
(Prioritized list of fixes)
```

**IMPORTANT:**
- Be thorough but efficient
- Document EVERY issue you find
- Include severity ratings (Critical/High/Medium/Low)
- Provide reproduction steps
- Suggest fixes where possible
- Focus on issues that block end-users

Start testing immediately. Report back when complete.
