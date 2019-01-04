FROM microsoft/dotnet:2.1-sdk AS build

WORKDIR /app


# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /app/aspnetapp
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/aspnetapp/out ./

ENV ASPNETCORE_URLS http://*:5050
EXPOSE 5050
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
