FROM cptactionhank/atlassian-jira-software:7.5.3


COPY ./jira/crack/atlassian-universal-plugin-manager-plugin-2.22.4.jar ${JIRA_INSTALL}/atlassian-jira/WEB-INF/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-2.22.4.jar
COPY ./jira/crack/atlassian-extras-3.2.jar ${JIRA_INSTALL}/atlassian-jira/WEB-INF/lib/atlassian-extras-3.2.jar

COPY ./mysql/driver/mysql-connector-java-8.0.25.jar ${JIRA_INSTALL}/atlassian-jira/WEB-INF/lib/mysql-connector-java-8.0.25.jar


CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]