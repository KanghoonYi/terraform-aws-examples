import type { APIGatewayProxyHandler } from 'aws-lambda';

const handler: APIGatewayProxyHandler = async () => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'hello',
    })
  };
}

export const main = handler;