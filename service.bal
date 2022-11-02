import ballerinax/github;
import ballerina/http;

configurable string accessToken = ?;

github:Client githubEp = check new (config = {
    auth: {
        token: accessToken
    }
});

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + orgName - the input string name
    # + no - repository name
    # + return - string name with hello message or error
    resource function get getStaredRepos(string orgName, int no) returns string[]?|error {
        // Send a response back to the caller.

        stream<github:Repository, error?> getRepositoriesResponse = check githubEp->getRepositories(orgName, true);

        string[]? repositories = check from var repo in getRepositoriesResponse
            order by repo.stargazerCount descending
            limit no
            select repo.name;

        return repositories;
    }
}
